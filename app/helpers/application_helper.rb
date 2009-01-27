# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def description(page_description)
    content_for(:description) { page_description }
  end

  def meta(page_meta)
    content_for(:meta) { page_meta }
  end

end
