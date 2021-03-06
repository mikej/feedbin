class SharingService < ApplicationRecord
  belongs_to :user
  default_scope { order('lower(label)') }

  def link_options(entry)
    entry_url = entry.fully_qualified_url ? ERB::Util.url_encode(entry.fully_qualified_url) : ''
    title = entry.title ? ERB::Util.url_encode(entry.title) : ''
    feed_name = entry.feed.title ? ERB::Util.url_encode(entry.feed.title) : ''
    share_url = self.url.clone
    share_url = share_url.gsub('${url}', entry_url).gsub('${title}', title).gsub('${source}', feed_name).gsub('${id}', entry.id.to_s)
    if share_url.start_with?('http')
      target = '_blank'
    else
      target = '_self'
    end
    {url: share_url, label: self.label, html_options: {target: target, rel: 'noopener noreferrer'}}
  end

  def active?
    true
  end
end
