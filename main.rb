require 'sinatra'
require 'sqlite3'
require 'securerandom'
require 'fileutils'
#require 'sinatra/json'#インストールしたやつ　読み込みだよ！

db = SQLite3::Database.new "pixiv_clone_db"
db.results_as_hash = true

# postsというtableをcreate
# sql = <<SQL
#   create table posts (
#   image varchar(200)
# );
# SQL

# db.execute(sql)

# insertして画像の情報を追加(毎回追加されるからコメントアウト)
# sql = "insert into posts values (:image)"
# db.execute(sql, :image => 'hun.png')



#トップページにきたらここの処理が走る
get '/' do
  #トップページを表示する前にする処理
  # @をつけてview側で呼べるように
  @posts = db.execute("select * from posts;")

  # postテーブルから情報をひっぱってくる
  # db.execute('select * from posts') do |row|
  #   @row = row
  # end

  erb :index
  #erbはhtmlの中にrubyを埋め込んだもの

end


post '/' do
  p params
  if params["file"][:type].include? "jpg"
    ext = "jpg"

  elsif params["file"][:type].include? "png"
    ext = "png"

  end

  file_name = SecureRandom.hex + "." + ext

  FileUtils.mv(params["file"][:tempfile], "./public/uploads/" + file_name)

  stmt = db.prepare("INSERT INTO posts (img_file_name, text) VALUES (?, ?)")
  stmt.bind_params(file_name, params['ex_text'])
  stmt.execute

  @posts = db.execute("select * from posts;")
  # sql = "insert into posts (image) values ('" + @name + "')"
  # p sql
  # db.execute(sql)

  erb :index

end

get '/star' do
  post_id = params["post_id"].to_i
  post = db.execute("SELECT star_count FROM posts WHERE id = ?", post_id)

  new_star_count = post[0]["star_count"] + 1
  db.execute("UPDATE posts SET star_count = ? WHERE id=?", new_star_count, post_id)
  return "スターをつけました"
end
