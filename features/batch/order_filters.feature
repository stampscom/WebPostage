Feature: As a batch shipper, I want to be able to filter orders by status [B-01621]

  Background:
    Given I am signed in as a Batch user

  Scenario: User Views Filter Panel
    * User views the Orders tab
    * System displays expanded filters panel.
    * System displays "Awaiting Shipment" and "Shipped" filters in panel.
    * System selects the "Awaiting Shipment" filter by default.