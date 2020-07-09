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
    isbn = isbn_path.children.first.content if isbn_path.children.first
    next if isbn.nil?
    title = get_value_from_result(doc, '//title_without_series', i)
    print(file, "#{isbn}, #{title}, #{author_last_name}")
  end
end

def get_author_books(author_name, file)
  last_name = author_name.split(' ').last
  author_id = find_author_id(author_name)
  5.times do |page|
    get_books(author_id, page + 1, last_name, file)
  end
end

def run(author_list)
  file = open('run_5.txt', 'a')
  author_list.each_with_index do |author, i|
    puts "*************** #{author} #{i} / 100 ***********************"
    get_author_books(author, file)
  end
end

# rubocop:disable Style/StringLiterals

author_list = [
  "Akira Toriyama",
  "Alexander Pushkin",
  "Alistair MacLean",
  "Andrew Neiderman",
  "Ann M. Martin",
  "Anne Golon",
  "Anne Rice",
  "Arthur Hailey",
  "Astrid Lindgren",
  "Barbara Cartland",
  "Beatrix Potter",
  "C. S. Lewis",
  "Cao Xueqin",
  "Carter Brown",
  "Catherine Cookson",
  "Clive Cussler",
  "Corín Tellado",
  "Dan Brown",
  "Danielle Steel",
  "David Baldacci",
  "Dean Koontz",
  "Debbie Macomber",
  "Denise Robins",
  "Dr. Seuss",
  "EL James",
  "Edgar Rice Burroughs",
  "Edgar Wallace",
  "Eiichiro Oda",
  "Eiji Yoshikawa",
  "Eleanor Hibbert",
  "Enid Blyton",
  "Erle Stanley Gardner",
  "Erskine Caldwell",
  "Evan Hunter",
  "Frank G. Slaughter",
  "Frédéric Dard",
  "Georges Simenon",
  "Gilbert Patten",
  "Gosho Aoyama",
  "Gérard de Villiers",
  "Harold Robbins",
  "Hermann Hesse",
  "Hirohiko Araki",
  "Horatio Alger",
  "Ian Fleming",
  "Irving Wallace",
  "J. K. Rowling",
  "J. R. R. Tolkien",
  "Jackie Collins",
  "James A. Michener",
  "James Patterson",
  "Janet Dailey",
  "Jeffrey Archer",
  "Jin Yong",
  "Jirō Akagawa",
  "John Creasey",
  "John Grisham",
  "Judith Krantz",
  "Karl May",
  "Ken Follett",
  "Kyotaro Nishimura",
  "Leo Tolstoy",
  "Lewis Carroll",
  "Louis L'Amour",
  "Mary Higgins Clark",
  "Masashi Kishimoto",
  "Michael Crichton",
  "Mickey Spillane",
  "Mitsuru Adachi",
  "Nicholas Sparks",
  "Nora Roberts",
  "Norman Bridwell",
  "Osamu Tezuka",
  "Patricia Cornwell",
  "Paulo Coelho",
  "Penny Jordan",
  "R. L. Stine",
  "René Goscinny",
  "Rex Stout",
  "Richard Scarry",
  "Roald Dahl",
  "Robert Ludlum",
  "Robin Cook",
  "Roger Hargreaves",
  "Rumiko Takahashi",
  "Ryōtarō Shiba",
  "Seiichi Morimura",
  "Sidney Sheldon",
  "Stan and Jan Berenstain",
  "Stephen King",
  "Stephenie Meyer",
  "Tite Kubo",
  "Wilbur Smith",
  "Yasuo Uchida",
  "Zane Grey"
]

# rubocop:enable Style/StringLiterals

run(author_list)
