#encoding: utf-8
namespace :delete_old do
  desc "Удаление очень старых записей"
  task delete: :environment do
    now = Time.now
    old = now - 3.month
    # old = now - 3.week

    Feed.where("updated_at <= :old", {old: old}).find_each do |feed|
      if feed.destroy
        puts "DELETE #{feed.id}, #{feed.title}, #{feed.updated_at}"
      else
        puts "ERROR #{feed.id}, #{feed.title}, #{feed.updated_at}"
      end
    end
  end

  desc "Удаление записей без даты"
  task delete_no_data: :environment do
    Feed.all.each do |feed|
      if feed.date.nil?
        feed.destroy
      end
    end
  end
end
