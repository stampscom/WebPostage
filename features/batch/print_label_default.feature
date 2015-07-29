@regression
Feature: B-01633 Change the starting label position I will print from - Default is Left Side

  @print_label_default @print_labels
  Scenario:  B-01633 - Default is Left Side
    * I am signed in as a batch shipper
    * Add new order
    * Set Recipient Address to B-01633, Default Label, 1990 E Grand Ave, El Segundo, CA, 90245
    * Set Phone to 415-795-5555
    * Set Email to rtest@stamps.com
    * Click Ship To Less button
    * Set Insured Value to $10.00
    * Set Service to Priority Mail Package
    * Click Toolbar Print Button
    * Expect default print label to be Left side
    * Close Print Window
    * Sign out
