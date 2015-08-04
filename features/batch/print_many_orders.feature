@regression
Feature: As a batch shipper, I want to be able to create and print many orders automatically

  Background:
    Given I am signed in as a batch shipper

  @print_many_orders
  Scenario:  Print Specified Number of Orders
    * Print 50 new orders with Address set to random and Service set to Priority Mail Package
    * Sign out