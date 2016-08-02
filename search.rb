#encoding: utf-8
require 'csv'
require './constants'

class Search
  include Constants

  attr_reader :total_page
  attr_reader :current_page

  def initialize(address_csv=nil)
    @address = address_csv
    @total_page = 1
    @current_page = 1
    puts "indexファイルの読込中・・・"
    read_index
  end

  def exec
    print "検索する文字列を入力(例 渋谷): "
    query = gets.chomp

    build_zip_code_array(query)
    print_addresses
    reset_instance_variables
  end

  private

  def build_zip_code_array(query)
    return false if invalid?(query)

    chars = query.chars.sort.reverse
    zip_code_array = []
    chars.each do |char|
      result = index.find{|row| row["key"] == char}.to_a
      result.shift
      return false if result.empty?
      zip_code_array << result.flatten.compact
    end

    zip_codes = zip_code_array.shift
    zip_code_array.each do |tmp_zip_codes|
      zip_codes = zip_codes & tmp_zip_codes
    end

    @zip_codes = zip_codes
  end

  def invalid?(query)
    /[a-z]/ === query
  end

  def zip_codes
    @zip_codes
  end

  def read_index
    index
  end

  def address
    @address ||= ::Address.new
  end

  def index
    @index ||= CSV.read(INDEX_FILE, headers: true)
  end

  def csv
    address.csv
  end

  def print_addresses
    return puts "該当0件" if zip_codes.nil? || zip_codes.empty?

    set_total_page(zip_codes)

    zip_codes_to_be_shown = zip_codes.first(PER_PAGE)
    print_addresses_through_zip_codes(zip_codes_to_be_shown)

    return unless zip_codes_to_be_shown.length < zip_codes.length
    loop do
      print "他のページを表示しますか？ (y/n)"
      answer = gets.chomp
      break unless answer == 'y'
      print "表示するページを入力してください (1 ~ #{total_page})"
      page = gets.chomp.to_i
      unless (1..total_page) === page
        puts "入力された値は不正です"
        break
      end
      set_current_page(page)

      zip_codes_to_be_shown = zip_codes[((page - 1) * PER_PAGE)..(page * PER_PAGE - 1)]
      print_addresses_through_zip_codes(zip_codes_to_be_shown)
    end
  end

  def set_current_page(page)
    @current_page = page
  end

  def set_total_page(zip_codes)
    @total_page = zip_codes.length / PER_PAGE
    @total_page += 1 unless (zip_codes.length % PER_PAGE).zero?
  end

  def print_addresses_through_zip_codes(zip_codes_to_be_shown)
    results = csv.find_all{|row| zip_codes_to_be_shown.any?{|val| val == row[2]}}.group_by{|row| row[2]}
    combined_results = combine(results)
    combined_results.each do |result|
      puts result.join(",")
    end
    puts " 表示: #{zip_codes_to_be_shown.length}件 #{current_page}/#{total_page}ページ ".center(80, '=')
  end

  def combine(results)
    combined_results = []
    results.each_pair do |zip_code, row|
      if row.length == 1
        combined_results << row.first
      else
        combined_str = row.reduce("") { |accum, val| accum << val[8] }
        combined_results << row.first[0..7] + [combined_str] + row.first[9..14]
      end
    end
    combined_results
  end

  def reset_instance_variables
    @zip_codes = nil
  end

end
