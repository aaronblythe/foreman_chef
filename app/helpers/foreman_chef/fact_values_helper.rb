module ForemanChef
  module FactValuesHelper
    def fact_name(value, parent)
      value_name = name = h(value.name)
      memo = ''
      name = name.split(FactName::SEPARATOR).map do |current_name|
        memo = memo.empty? ? current_name : memo + FactName::SEPARATOR + current_name
        if parent.present? && h(parent.name) == memo
          current_name
          else
            if value_name != memo || value.compose
              parameters = params.select { |k| k.to_s == 'host_id' }.merge(:parent_fact => memo)
              link_to(current_name, fact_values_path(parameters),
                      :title => _("Show all %s children fact values") % value_name)
            else
              link_to(current_name, fact_values_path("search" => "name = #{value_name}"),
                      :title => _("Show all %s fact values") % value_name)
            end
          end
      end.join(FactName::SEPARATOR).html_safe

      if value.compose
        link_to(image_tag('foreman_chef/plus.png', :alt => _('Expand nested items')),
                fact_values_path(:parent_fact => value_name)) + ' ' +
            content_tag(:strong, name)
      else
        name
      end
    end
  end
end