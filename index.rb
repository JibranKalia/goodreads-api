require 'Nokogiri'
require 'pry'
require 'HTTParty'

def print(file, csv_line)
  file.puts csv_line
  puts csv_line
end

def goodreads_call(url, query)
  query[:key] = 'eNZGpGUW00cnC7NXPdKA'
  headers = { 'Content-Type' => 'application/xml; charset=utf-8' }

  result = HTTParty.get(
    "https://www.goodreads.com/#{url}",
    query: query,
    headers: headers
  )
  sleep(0.5)
  Nokogiri::XML(result.body)
end

def get_value_from_result(doc, xpath, index = 0)
  doc.xpath(xpath)[index].children.first.content
end

def find_author_id(author_name)
  doc = goodreads_call('search/index.xml', search: 'author', q: author_name)
  get_value_from_result(doc, '//author/id')
end

def get_books(author_id, page, author_last_name, file)
  doc = goodreads_call('author/list.xml', id: author_id, page: page)

  doc.xpath('//isbn13').each_with_index do |isbn_path, i|
    isbn = isbn_path.children.first.content
    title = get_value_from_result(doc, '//title_without_series', i)
    print(file, "#{isbn}, #{title}, #{author_last_name}")
  end
end

def get_author_books(author_name, file)
  last_name = author_name.split(' ').last
  author_id = find_author_id(author_name)
  30.times do |page|
    begin
      get_books(author_id, page + 1, last_name, file)
    rescue NoMethodError => e
    end
  end
end

def run(author_list)
  file = open('run_4.txt', 'a')
  author_list.each_with_index do |author, i|
    puts "*************** #{author} #{i} / 100 ***********************"
    get_author_books(author, file)
  end
end

# rubocop:disable Style/StringLiterals

author_list = [
  # "Jin Yong",
  # "Karl May",
  # "Louis L'Amour",
  "Zane Grey",
  "Leo Tolstoy",
  "Andrew Neiderman",
  "Dan Brown",
  "James Patterson",
  "Arthur Hailey",
  "David Baldacci",
  "Mary Higgins Clark",
  "Patricia Cornwell",
  "Stephenie Meyer",
  "J. R. R. Tolkien",
  "C. S. Lewis",
  "Ann M. Martin",
  "Paulo Coelho",
  "Michael Crichton",
  "Edgar Rice Burroughs",
  "Sidney Sheldon",
  "Irving Wallace",
  "Hermann Hesse",
  "Ken Follett",
  "Jeffrey Archer",
  "Eleanor Hibbert",
  "Barbara Cartland",
  "Danielle Steel",
  "Corín Tellado",
  "Jackie Collins",
  "Nora Roberts",
  "Janet Dailey",
  "Debbie Macomber",
  "Catherine Cookson",
  "Nicholas Sparks",
  "Judith Krantz",
  "Denise Robins",
  "Penny Jordan",
  "Alexander Pushkin",
  "Beatrix Potter",
  "Rex Stout",
  "Erle Stanley Gardner",
  "Jirō Akagawa",
  "Kyotaro Nishimura",
  "Yasuo Uchida",
  "Seiichi Morimura",
  "Eiji Yoshikawa",
  "Robin Cook",
  "Frank G. Slaughter",
  "Mitsuru Adachi",
  "Eiichiro Oda",
  "Masashi Kishimoto",
  "Hirohiko Araki",
  "Akira Toriyama",
  "Gosho Aoyama",
  "Tite Kubo",
  "Osamu Tezuka",
  "Rumiko Takahashi",
  "Erskine Caldwell",
  "John Grisham",
  "Ian Fleming",
  "Richard Scarry",
  "Dean Koontz",
  "Stephen King",
  "Ryōtarō Shiba",
  "James A. Michener",
  "J. K. Rowling",
  "Anne Rice",
  "R. L. Stine",
  "René Goscinny",
  "EL James",
  "Robert Ludlum",
  "Cao Xueqin",
  "Horatio Alger",
  "Gérard de Villiers",
  "Georges Simenon",
  "Frédéric Dard",
  "Mickey Spillane",
  "Evan Hunter",
  "Edgar Wallace",
  "Carter Brown",
  "John Creasey",
  "Norman Bridwell",
  "Enid Blyton",
  "Roger Hargreaves",
  "Dr. Seuss",
  "Roald Dahl",
  "Astrid Lindgren",
  "Stan and Jan Berenstain",
  "Anne Golon",
  "Lewis Carroll",
  "Wilbur Smith",
  "Alistair MacLean",
  "Clive Cussler",
  "Harold Robbins",
  "Gilbert Patten"
]

# rubocop:enable Style/StringLiterals

run(author_list)
