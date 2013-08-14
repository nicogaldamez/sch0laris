# encoding: UTF-8
class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
    
    add_column :users, :school_id, :integer
    add_column :users, :other_school, :string
    
    add_index :users, :school_id
    add_index :schools, :name, :unique => true
    add_index :schools, :acronym, :unique => true
    
    # Creo las facultades
    School.create(name: 'UNLP - Facultad de Arquitectura y Urbanismo')
    School.create(name: 'UNLP - Facultad de Bellas Artes')
    School.create(name: 'UNLP - Facultad de Cs. Agrarias y Forestales')
    School.create(name: 'UNLP - Facultad de Cs. Astronómicas y Geofísicas')
    School.create(name: 'UNLP - Facultad de Cs. Económicas')
    School.create(name: 'UNLP - Facultad de Cs. Exactas')
    School.create(name: 'UNLP - Facultad de Cs. Médicas')
    School.create(name: 'UNLP - Facultad de Cs. Veterinarias')
    School.create(name: 'UNLP - Facultad de Humanidades y Cs. de la Educación')
    School.create(name: 'UNLP - Facultad de Informática')
    School.create(name: 'UNLP - Facultad de Ingeniería')
    School.create(name: 'UNLP - Facultad de Odontología')
    School.create(name: 'UNLP - Facultad de Periodismo y Com. Social')
    School.create(name: 'UNLP - Facultad de Psicología')
    School.create(name: 'UNLP - Facultad de Trabajo Social')
  end
end