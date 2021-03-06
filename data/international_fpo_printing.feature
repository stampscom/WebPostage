
Feature:  B-01813 - Allow Int'l and APO/FPO Printing (CN22 and CP72)

  Background:
    Given I am signed in as a batch shipper

	
  Scenario:  User Prints FPO Address
    And I Add a new order
    * Set Ship From to default
    * Set Ship-To country to United States
    * Set Ship-To address to FPO address
    * Open Customs Form
    * Set Customs Form Package Contents to Merchandise
    * Set Customs Form Weight(oz) to 1
    * Add Customs Form Item 1 to Description=random, Qty 1, Unit Price 2500, Weight(lbs) 0, Weight(oz) 1 Origin United States, Tariff 10
    * Check Customs Form "I agree to the USPS Privacy Act Statement and Restrictions and Prohibitions"
    * Close Customs Information Modal
    * Set Service to First-Class Mail International Large Envelope
    * Print