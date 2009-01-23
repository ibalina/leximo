class WordSweeper < ActionController::Caching::Sweeper
  observe Word # This sweeper is going to keep an eye on the Word model

  # If our sweeper detects that a Word was created call this
  def after_create(word)
          expire_cache_for(word)
  end
  
  # If our sweeper detects that a Word was updated call this
  def after_update(word)
          expire_cache_for(word)
  end
  
  # If our sweeper detects that a Word was deleted call this
  def after_destroy(word)
          expire_cache_for(word)
  end
          
  private
  def expire_cache_for(record)

    expire_fragment(:controller => 'words', :action => 'index')
    expire_fragment(:controller => 'words', :action => 'recent')
    
    expire_fragment(:controller => 'words', :action => 'show', :id => record.id)

  end
end
