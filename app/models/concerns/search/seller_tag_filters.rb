module Concerns::Search::SellerTagFilters
  def start_up_filter(relation)
    if filter_selected?(:business_identifiers, :start_up)
      relation.start_up
    else
      relation
    end
  end

  def sme_filter(relation)
    if filter_selected?(:business_identifiers, :sme)
      relation.sme
    else
      relation
    end
  end

  def disability_filter(relation)
    if filter_selected?(:business_identifiers, :disability)
      relation.disability
    else
      relation
    end
  end

  def regional_filter(relation)
    if filter_selected?(:business_identifiers, :regional)
      relation.regional
    else
      relation
    end
  end

  def not_for_profit_filter(relation)
    if filter_selected?(:business_identifiers, :not_for_profit)
      relation.not_for_profit
    else
      relation
    end
  end

  def indigenous_filter(relation)
    if filter_selected?(:business_identifiers, :indigenous)
      relation.indigenous
    else
      relation
    end
  end

  def govdc_filter(relation)
    if filter_selected?(:govdc, :govdc)
      relation.govdc
    else
      relation
    end
  end
end
