class Page < ApplicationRecord
  resourcify

  belongs_to :site
  has_many :blocks, dependent: :destroy
  has_many :components, through: :blocks
  before_create :check_empty
  after_save :set_url

  searchable do
    text :title, stored: true
    text(:text, stored: true) do
      components.map { |comp| comp.content if comp.kind == "text" }.join(' ')
    end
  end
  
  def update_blocks(blocks_hash, new_layout = nil)
    return unless blocks_hash
    destroy_deleted_components blocks_hash
    if layout != new_layout
      blocks.destroy_all
      PagesController.helpers.blocks(new_layout.to_sym).each do |position|
        blocks.create(:position => position)
      end
    end
    blocks.each { |block| update_component block, blocks_hash[block.position.to_s] }
  end

  def update_component(block, comp_data)
    comp_data.each_pair do |order, data|
      if data["id"]
        comp = block.components.find(data["id"])
      else
        comp = block.components.new
      end
      comp[:order] = order
      comp[:kind], comp[:content] = data.to_a.flatten
      comp.save if comp[:content].present?
    end
  end

  def destroy_deleted_components(blocks_hash)
    new_ids = blocks_hash.values.flat_map { |block| block.values.map { |comp| comp["id"] } }
    new_ids = new_ids.compact.map! { |x| x.to_i }
    old_ids = components.all.to_a.map { |comp| comp.id }
    (old_ids - new_ids).each { |id| Component.find(id).destroy }
  end

  def check_empty
    self.title = "Untitled page" unless title.present?
  end

  def set_url
    unless url.present?
      update_attribute :url, Rails.application.routes.url_helpers.user_site_page_path(
                         :locale => "en",
                         :user_id => site.user_id,
                         :site_id => site.id,
                         :id => id)
    end
  end
end
