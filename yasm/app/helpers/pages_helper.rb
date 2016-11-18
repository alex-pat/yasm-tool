module PagesHelper

  LAYOUTS = {
    :olivia => %w(center),
    :ivy    => %w(left right),
    :tori   => %w(top bottom-left bottom-right)
  }.freeze
  LAYOUT_NAMES = LAYOUTS.keys.freeze
  OPTIONS = ["<option value='table'>#{I18n.t("components.tables.types.table")}</option>",
             "<option value='pie2d'>#{I18n.t("components.tables.types.pie2d")}</option>",
             "<option value='pie3d'>#{I18n.t("components.tables.types.pie3d")}</option>",
             "<option value='line'>#{I18n.t("components.tables.types.line")}</option>",
             "<option value='area2d'>#{I18n.t("components.tables.types.area2d")}</option>",
             "<option value='bar2d'>#{I18n.t("components.tables.types.bar2d")}</option>",
             "<option value='bar3d'>#{I18n.t("components.tables.types.bar3d")}</option>",
             "<option value='column2d'>#{I18n.t("components.tables.types.column2d")}</option>",
             "<option value='column3d'>#{I18n.t("components.tables.types.column3d")}</option>",
             "<option value='doughnut2d'>#{I18n.t("components.tables.types.doughnut2d")}</option>",
             "<option value='doughnut3d'>#{I18n.t("components.tables.types.doughnut3d")}</option>"]

  def blocks(name)
    LAYOUTS[name]
  end

  def layouts
    LAYOUT_NAMES
  end

  def table_options(type)
    options = OPTIONS.clone
    index = options.find_index { |x| x.include? type }
    opt = options.delete_at index 
    options.unshift(opt).join.html_safe
  end
end
