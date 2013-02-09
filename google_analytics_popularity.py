#!/usr/bin/python2.7
# -*- coding: utf-8 -*-
#Based on: https://developers.google.com/analytics/solutions/articles/hello-analytics-api

import sys

#Import strftime to get accurate popularity results
from time import strftime

# import the Auth Helper class
import hello_analytics_api_v3_auth

from apiclient.errors import HttpError
from oauth2client.client import AccessTokenRefreshError

def main(argv):
  # Initialize the Analytics Service Object
  service = analytics_api_auth.initialize_service()

  try:
    # Query APIs, print results
    profile_id = get_first_profile_id(service)

    if profile_id:
      results = get_results(service, profile_id)
      print_results(results)

  except TypeError, error:
    # Handle errors in constructing a query.
    print ('There was an error in constructing your query : %s' % error)

  except HttpError, error:
    # Handle API errors.
    print ('Arg, there was an API error : %s : %s' %
           (error.resp.status, error._get_reason()))

  except AccessTokenRefreshError:
    # Handle Auth errors.
    print ('The credentials have been revoked or expired, please re-run '
           'the application to re-authorize')


def get_first_profile_id(service):
  # Get a list of all Google Analytics accounts for this user
  accounts = service.management().accounts().list().execute()

  if accounts.get('items'):
    # Get the first Google Analytics account
    firstAccountId = accounts.get('items')[0].get('id')

    # Get a list of all the Web Properties for the first account
    webproperties = service.management().webproperties().list(accountId=firstAccountId).execute()

    if webproperties.get('items'):
      # Get the first Web Property ID
      firstWebpropertyId = webproperties.get('items')[0].get('id')

      # Get a list of all Profiles for the first Web Property of the first Account
      profiles = service.management().profiles().list(
          accountId=firstAccountId,
          webPropertyId=firstWebpropertyId).execute()

      if profiles.get('items'):
        # return the first Profile ID
        return profiles.get('items')[0].get('id')

  return None

def get_results(service, profile_id):
  # Use the Analytics Service Object to query the Core Reporting API
  return service.data().ga().get(
      ids='ga:' + profile_id,
				#Ask only about the current day      
      start_date= strftime("%Y-%m-%d"),
      end_date= strftime("%Y-%m-%d"),
      metrics='ga:visits').execute()


def print_results(results):
  # Print data about today's visist.
  if results:
    print results.get('rows')[0][0]

  else:
    print 'No results found'


if __name__ == '__main__':
  main(sys.argv)