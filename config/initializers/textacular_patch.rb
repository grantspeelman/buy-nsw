# This fixes an issue with Texacular where an invalid query is generated when
# a search is combined with eager loading.
#
# Patch adopted from the GitHub issue here:
# https://github.com/textacular/textacular/issues/87
#
module Textacular

  def assemble_query(similarities, conditions, exclusive)
    select("#{quoted_table_name + '.*,' if select_values.empty?} #{similarities.join(" + ")}").
      where(conditions.join(exclusive ? " AND " : " OR ")).
      order("#{similarities.join(" + ")} DESC")
  end

end
