namespace :manage_event do

  desc "Remove the date point event over six months"
  task :delete_last_date_point_event => :environment do
    DateEvent.delete_all(["id in (?)", DateEvent.get_ids_date_event_old])
  end

  desc "Generate new date point"
  task :generate_new_date_point => :environment do

  end

end