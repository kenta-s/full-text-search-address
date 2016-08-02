#encoding: utf-8
require 'csv'
require './constants'

class Address
  include Constants

  def initialize
    puts "CSVファイルの読み込み開始・・・"
    read_csv
  end

  def create_index!
    build_transposed_data
    puts "indexファイルの保存中・・・"

    CSV.open(INDEX_FILE,'w') do |index|
      index << ["key"]
      @transposed_data.each do |row|
        index << row.flatten
      end
    end

    puts "ファイル名: #{INDEX_FILE} を作成しました"
  end

  def csv
    @csv ||= CSV.read(CSV_FILE, encoding: "Shift_JIS:UTF-8")
  end

  private

  def read_csv
    csv
  end

  def build_transposed_data
    header = []
    body = []

    csv.each do |row|
      puts row.join(",")
      chars = row.join.chars.uniq
      chars.each do |char|
        if header.include?(char)
          body[header.index(char)] << row[2]
        else
          header << char
          body[header.index(char)] = [row[2]]
        end
      end
    end
    @transposed_data = [header, body].transpose
  end

end
