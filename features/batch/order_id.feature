
Feature: New Order ID Created

  Background:
    Given I am signed in as a batch shipper

  @order_id @regression
  Scenario:  New Order ID Created
    And I Add a new order
    Then Expect new Order ID created
    Then Expect Single Order Form Order ID equals Grid order ID
    And Sign out
