module Batch

  class CustomsItem < BatchObject

    def description
      Textbox.new @browser.text_field :name => "CustomsItemName"
    end

    def qty
      Textbox.new @browser.text_field :name => "CustomsItemQuantity"
    end

    def qty_increment value

    end

    def qty_decrement value

    end

    def unit_price
      Textbox.new @browser.text_field :name => "CustomsItemPrice"
    end

    def unit_price_increment value

    end

    def unit_price_decrement value

    end

    def lbs
      Textbox.new @browser.text_field :name => "CustomsItemWeightLb"
    end

    def lbs_increment value

    end

    def lbs_decrement value

    end

    def oz
      Textbox.new @browser.text_field :name => "CustomsItemWeightOz"
    end

    def oz_increment value

    end

    def oz_decrement value

    end

    def origin_dd
      drop_down = (@browser.divs :css => "div[id^=combo-][id$=-trigger-picker]").last
      raise "Drop-down button is not present.  Check your CSS locator." unless drop_down.present?
      input = (@browser.text_fields :name => "OriginCountry").last
      raise "Drop-down button is not present.  Check your CSS locator." unless input.present?
      Dropdown.new @browser, drop_down, "li", input
    end

    def hs_tariff
      Textbox.new @browser.text_field :name => "HSTariff"
    end

  end

  class UspsPrivactActStatementModal < BatchObject
    def window_title
      Label.new @browser.div :text => "USPS Privacy Act Statement"
    end

    def present?
      window_title.present?
    end

    def okay
      @browser.span :text => "OK"
    end

  end

  class RestrictionsAndProhibitionsModal < BatchObject

    def present?

    end

  end

  class CustomsForm < BatchObject
    public

    def present?
      Button.new @browser.image :css => "img[class*='x-tool-close']"
    end

    def package_contents_dd
      drop_down = @browser.div :id => "sdc-customsFormWindow-packagecontentsdroplist-trigger-picker"
      raise "Drop-down button is not present.  Check your CSS locator." unless browser_helper.present? drop_down
      input = pacakge_contents.field
      raise "ContentType is not present.  Check your CSS locator." unless browser_helper.present? input
      Dropdown.new @browser, drop_down, "li", input
    end

    def pacakge_contents
      Textbox.new @browser.text_field :name => "ContentType"
    end

    def non_delivery_options_dd
      drop_down = @browser.div :id => "sdc-customsFormWindow-nondeliveryoptionsdroplist-trigger-picker"
      raise "Drop-down button is not present.  Check your CSS locator." unless browser_helper.present? drop_down
      input = @browser.text_field :name => "NonDeliveryOption"
      raise "NonDeliveryOption is not present.  Check your CSS locator." unless browser_helper.present? input
      Dropdown.new @browser, drop_down, "li", input
    end


    def internal_transaction_dd
      drop_down = @browser.div :id => "sdc-customsFormWindow-internaltransactiondroplist-trigger-picker"
      raise "Drop-down button is not present.  Check your CSS locator." unless browser_helper.present? drop_down
      input = @browser.text_field :name => "isITNRequired"
      raise "isITNRequired is not present.  Check your CSS locator." unless browser_helper.present? input
      Dropdown.new @browser, drop_down, "li", input
    end

    def more_info
      Textbox.new @browser.text_field :name => "Comments"
    end

    def itn_number
      div = (@browser.divs :css => "div[id^=textfield][class*=x-hbox-form-item]").last
      text_field = @browser.text_field :css => "input[name=ITN][maxlength='50']"
      Textbox.new text_field, div
    end

    def license
      Textbox.new @browser.text_field :css => "input[name=LicenseNumber]"
    end

    def certificate
      Textbox.new @browser.text_field :css => "input[name=CertificateNumber]"
    end

    def invoice
      Textbox.new @browser.text_field :css => "input[name=InvoiceNumber]"
    end



    def item
      CustomsItem.new @browser
    end

    def plus

    end

    def add_item
      Button.new @browser.spans :text => "Add Item"
    end

    def total_weight_label
      divs = @browser.divs :css => "div[class*=x-form-display-field-default]"
      div = divs[1]
      present = browser_helper.present? div
      log "Total Weight: #{browser_helper.text div}" # 0 lbs. 0 oz.
      div
    end

    def total_weight_lbs
      lbs = total_weight_label.scan(/\d+/).first
      log "Pounds: #{lbs}"
      lbs
    end

    def total_weight_oz
      oz = total_weight_label.scan(/\d+/).last
      log "Ounces: #{oz}"
      oz
    end

    def total_value_label
      divs = @browser.divs :css => "div[class*=x-form-display-field-default]"
      div = divs.last
      log "Total Value label is #{(browser_helper.present? div)? 'present' : 'not present'}"
      div
    end

    def total_value
      test_helper.remove_dollar_sign total_value_label
    end

    def verify_i_agree_checked
      div = @browser.div :css => "div[id^=checkboxfield][style^=right]"
      attribute_value = browser_helper.attribute_value div
      checked = attribute_value.include? "checked"
      log "I agree is #{(checked)? 'checked' : 'unchecked'}"
      checked
    end

    def i_agree_checkbox
      text_fields = @browser.text_fields :css => "input[id^=checkboxfield]"
      text_field = text_fields.last
      log "I Agree Checkbox is #{(browser_helper.present? text_field)?'Present' : 'Not Present'}"
      text_field
    end

    def i_agree user_agreed

      checkbox_fields = @browser.inputs :css => "input[id^=checkbox-][id$=-inputEl]"
      checkbox_field = checkbox_fields.last

      verify_fields = @browser.inputs :css => "div[id^=checkbox][class*=x-form-type-checkbox]"
      verify_field = verify_fields.last
      checkbox = Stamps::Browser::Checkbox.new checkbox_field, verify_field, "class", "checked"

      if user_agreed
        checkbox.check
        log checkbox.checked?
      else
        checkbox.uncheck
        log checkbox.checked?
      end

    end

    def privacy_act_statement_link
      link = @browser.span :text => "USPS Privacy Act Statement"
      log "USPS Privacy Act Statement is #{(browser_helper.present? link)?'Present' : 'Not Present'}"
      link
    end

    def usps_privacy_act_statement
      privacy_statement = UspsPrivactActStatementModal.new @browser
      5.times{
        browser_helper.safe_click privacy_act_statement_link
        return privacy_statement if privacy_statement.present?
      }
    end

    def restrictions_prohibitions_link
      link = @browser.span :text => "Restrictions and Prohibitions"
      log "Restrictions and Prohibitions is #{(browser_helper.present? link)?'Present' : 'Not Present'}"
      link
    end

    def restrictions_and_prohibitions
      restrictions_link = RestrictionsAndProhibitionsModal.new @browser
      5.times{
        browser_helper.safe_click restrictions_prohibitions_link
        return restrictions_link if restrictions_link.present?
      }
    end

    def close
      (Button.new @browser.span :text => "Close").click_while_present
    end

    def cancel
      (Button.new @browser.img :css => "img[class$=x-tool-close]").click_while_present
    end
  end

end
