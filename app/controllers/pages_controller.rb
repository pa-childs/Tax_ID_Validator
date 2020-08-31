class PagesController < ApplicationController

  def about

  end

  def home

    countries = Countries.all
    @country_list = countries.collect { |item|
      [item[:name], item[:alias]]
    }

  end

  def validate

    # Australin ABN Number: 51 824 753 556 - Valid
    #                       11 111 111 111 - Invalid
    # EU VAT Number:        DE345789003 - Synatx Good - Not Valid
    #                       IE6388047V - Synatx Good - Valid
    #                       LU21416127 - Synatx Good - Not Valid
    # South African Number: 4023340283 - Not Valid

    country_code = params['validate']['country']
    tax_id = params['validate']['tax_id']
    eu_countries = ['AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR',
                    'DE', 'GR', 'HU', 'IE', 'IT', 'LT', 'LV', 'LU', 'MT', 'NL',
                    'NO', 'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE', 'CH', 'GB']

    unless country_code.blank? and tax_id.blank?

      logger.info "Checking Tax ID Values -- Country Code: #{country_code}  Tax ID: #{tax_id}."

      # Validate code based on the Country Code
      if country_code == "AU"

        validate_australian_abn(tax_id)

      elsif country_code == "ZA"

        validate_south_african_vat(country_code, tax_id)

      elsif eu_countries.include? country_code

        validate_european_union_vat(country_code, tax_id)

      else

        # Most countries are not supported by the gems used by Tax ID Validator
        flash[:unsppported] = t('.unsupported_text')
        redirect_to root_path

      end

    else

      logger.info "Missing Required Values -- Country Code: #{country_code}  Tax ID: #{tax_id}."
      flash[:alert] = t('.required_fields_text')
      redirect_to root_path

    end

  end

end

private

def validate_australian_abn(abn_number)

  if ABN.new(abn_number).valid?

    flash[:notice] = "#{t('.abn_number_text')} #{abn_number} #{t('.tax_id_valid_text')}"
    redirect_to root_path

  else

    flash[:alert] = "ABN Number #{abn_number} #{t('.tax_id_invalid_text')}"
    redirect_to root_path

  end

end

def validate_european_union_vat(code, vat_number)

  # This validation doesn't confirm the supplied country code and VAT are matched, but that doesn't affect VAT validation results

  # Valvat.new(vat_number).valid?                   # verify the syntax of a VAT number - WEAKEST METHOD
  result = Valvat.new(vat_number).exists?           # verify the given VAT number exists via the VIES web service
  # result = Valvat::Lookup.validate(vat_number)    # lookup a VAT number string directly via VIES web service

  logger.info "VIES web service returned: #{result}."

  if result == true

    flash[:notice] = "#{code}#{t('.vat_number_text')} #{vat_number} #{t('.tax_id_valid_text')}"
    redirect_to root_path

  elsif result == false

    flash[:alert] = "#{code}#{t('.vat_number_text')} #{vat_number} #{t('.tax_id_invalid_text')}"
    redirect_to root_path

  else

    # Should only happen when a nil is returned for the .exists and lookup checks
    flash[:alert] = t('.vies_service_down')
    redirect_to root_path

  end

end

def validate_south_african_vat(code, vat_number)

  if vat_number.valid_sa_vat_number?

    flash[:notice] = "#{code}#{t('.vat_number_text')} #{vat_number} #{t('.tax_id_valid_text')}"
    redirect_to root_path

  else

    flash[:alert] = "#{code}#{t('.vat_number_text')} #{vat_number} #{t('.tax_id_invalid_text')}"
    redirect_to root_path

  end

end
