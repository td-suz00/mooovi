class Scraping
  def self.movie_urls
    # 映画の個別ページのURLを取得
    # get_product(link)を呼び出す

    #①linksという配列の空枠を作る
    links = []
    #②Mechanizeクラスのインスタンスを生成する
    agent = Mechanize.new

    # パスの部分を変数で定義(はじめは、空にしておきます)
    next_url = ""

    while true do
      #③映画の全体ページのHTMLを取得
      current_page = agent.get("http://review-movie.herokuapp.com/" + next_url)
      #④全体ページから映画20件の個別URLのタグを取得
      elements = current_page.search('.entry-title a')
      #⑤個別URLのタグからhref要素を取り出し、links配列に格納する
      elements.each do |ele|
        links << ele.get_attribute('href')
      end

      # 「次へ」を表すタグを取得
      next_link = current_page.at('.pagination .next a')

      # next_linkがなかったらwhile文を抜ける
      unless next_link
        break
      end

      # そのタグからhref属性の値を取得
      next_url = next_link.get_attribute('href')

    end
    #⑥get_productを実行する際にリンクを引数として渡す
    links.each do |link|
      get_product('http://review-movie.herokuapp.com' + link)
    end
  end

  def self.get_product(link)
    # 「作品名」と「作品画像のURL」をスクレイピング
    # スクレイピングした「作品名」と「作品画像のURL」をProductsテーブルに保存

    #⑦Mechanizeクラスのインスタンスを生成する
    agent = Mechanize.new
    #⑧映画の個別ページのHTMLを取得
    page = agent.get(link)
    #⑨inner_textメソッドを利用し映画のタイトルを取得
    title = page.at('.entry-title').inner_text
    #①⓪image_urlがあるsrc要素のみを取り出す
    image_url = page.at('.entry-content img')[:src] if page.at('.entry-content img')

    director = page.at('.director span').inner_text if page.at('.director span')
    detail = page.at('.entry-content p').inner_text if page.at('.entry-content p')
    open_date = page.at('.date span').inner_text if page.at('.date span')

    #①①newメソッド、saveメソッドを使い、スクレイピングした「映画タイトル」と「作品画像のURL」をproductsテーブルに保存
    product = Product.where(title: title).first_or_initialize
    product.image_url = image_url
    product.director = director
    product.detail = detail
    product.open_date = open_date
    product.save
  end
end
























