module Batch
  class AddressNotFound < Stamps::BrowserObject
    include SingleOrderCommon

    private
    def exact_address_not_found_field
      @browser.div :text => 'Exact Address Not Found'
    end

    public
    def exact_address_not_found?
      browser_helper.field_present?  exact_address_not_found_field
    end

    def row=(number=0)
      row = number.to_i<=0?0:number.to_i-1
      rox_input = @browser.input :css => "input[name=addrAmbig][value='#{row}']"
      accept_button = @browser.span :text => 'Accept'
      3.times do
        begin
          rox_input.click
          checked = rox_input.attribute_value("checked")
          yyy=rox_input.attribute_value("checked").include? "checked"
          if checked
            accept_button.click
            accept_button.wait_while_present
            break
          end
        rescue
          #ignore
        end
      end
    end

    def set(partial_addy)
      expand_ship_to
      browser_helper.set_text address_textbox, BatchHelper.instance.formatAddress(partial_addy), 'Address'
      10.times {
        item_label.click
        break if (browser_helper.field_present?  exact_address_not_found_field) || (browser_helper.field_present?  validate_address_link)
      }
      less
      self
    end
  end
end