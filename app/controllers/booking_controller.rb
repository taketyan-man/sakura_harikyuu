class BookingController < ApplicationController
  before_action :host_is, only: [:host_login, :host, :host_logout]

  def index
    @reservations = BookingDate.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
  end

  def new
    @reservation = BookingDate.new
    @day = params[:day]
    @time = params[:time]
    @start_time = DateTime.parse(@day + " " + @time + " " + "JST")
    if @day.to_date < Date.current
      flash[:notice] =  ["過去の日付は選択できません", "正しい日付を選択してください"]
      redirect_to booking_date_path
    elsif @day.to_date < (Date.current + 1)
      flash[:notice] = ["当日は選択できません","正しい日付を選択してください"]
      redirect_to booking_date_path
    elsif (Date.current >> 3) < @day.to_date
      flash[:notice] =  ["3ヶ月以降の日付は選択できません。正しい日付を選択してください。", "最初から選択してください"]
      redirect_to booking_date_path
    end
  end
  
  def show
    @reservation = BookingDate.find(params[:id])
    @menu = menus[@reservation.menu]
    @option = options[@reservation.option]
    flash.keep(:success)
  end

  
  def create
    @reservation = BookingDate.new(
      day:        params[:day],
      time:       params[:time],
      start_time: params[:start_time],
      name:       params[:name],
      tell:       params[:tell],
      menu:       params[:menu],
      option:     params[:option],
      s_time:     params[:time]
    )
    flash[:success] = []
    flash[:notice] = []
    @reservation.time = times.index(params[:time])
    @reservation[:date_time] = @reservation.day.to_s + params[:time]
    first_time_num = @reservation.time
    @false_count = 0
    @reservation[:option].nil? ? (@reservation[:option] = 0) : (@reservation[:option] = params[:option])
    if @reservation[:menu].nil? || @reservation[:name].nil? || @reservation[:tell].nil?
      flash[:notice] << "入力されていないものがあります。"
      @false_count = -1
    elsif @reservation[:name] == "ホスト"
      flash[:notice] << "その名前では登録できません"
      @false_count = -1
    elsif @reservation[:menu] % 3 == 0 && @reservation[:option] == 1 #60分のコース選んだ時オプションあり
      pre_create_cmd(@reservation.time, 3, @false_count)
    elsif @reservation[:menu] % 3 == 1 && @reservation[:option] == 1 #90分のコース選んだ時オプションあり
      pre_create_cmd(@reservation.time, 4, @false_count)
    elsif @reservation[:menu] % 3 == 2 && @reservation[:option] == 1 #120分コース選んだオプションあり
      pre_create_cmd(@reservation.time, 5, @false_count)
    elsif @reservation[:menu] % 3 == 0 && @reservation[:option] == 0 #60分のコース選んだ時オプションなし
      pre_create_cmd(@reservation.time, 2, @false_count)
    elsif @reservation[:menu] % 3 == 1 && @reservation[:option] == 0 #90分のコース選んで時オプションなし
      pre_create_cmd(@reservation.time, 3, @false_count)
    elsif @reservation[:menu] % 3 == 2 && @reservation[:option] == 0 #120分のコース選んで時オプションなし
      pre_create_cmd(@reservation.time, 4, @false_count)
    else
      flash[:notice] << "何か問題があります。"
      @false_count = -1
    end
    
    if @false_count <= -1
      BookingDate.where(day: @reservation.day, s_time: @reservation.s_time, e_time: @reservation.e_time).destroy_all
      flash[:success] = nil
      redirect_to booking_date_new_path(day: @reservation.day, time:  params[:time])
    elsif @false_count == 0
      flash[:success] << "予約が完了しました。"
      flash[:notice] = nil
      redirect_to action: :show,id: @reservation.id
    elsif @false_count > 0
      BookingDate.where(day: @reservation.day, s_time: @reservation.s_time, e_time: @reservation.e_time).destroy_all
      flash[:success] = nil
      flash[:notice].push("すでに予約が入っています。", "他の時間で予約してください。")
      redirect_to booking_date_path
    else
      @reservation.delete
      flash[:success] = nil 
      flash[:notice] << "何か問題が起きました。"
      redirect_to booking_date_path
    end
  end 
  
  def delete
    date_time_now = params[:date_time]
    @reservation = BookingDate.find_by(date_time: date_time_now)
    if @reservation.menu == 10
      BookingDate.where(day: @reservation.day, name: @reservation.name).destroy_all
      flash[:success] = "その日の予定は削除されました。"
      redirect_to host_path
    else
      BookingDate.where(day: @reservation.day, s_time: @reservation.s_time, e_time: @reservation.e_time, name: @reservation.name).destroy_all
      flash[:notice] = "予約は削除されました。"
      if session[:user_id].is_a?(Integer) && session[:user_id] == 1 #ホストがログイン中ならhost_pathへ
        redirect_to host_path
      else  #ホスト以外の方ならbooking_date_pathへ
        redirect_to booking_date_path
      end
    end
  end
  
  def host
    @host = Host.new
  end
  
  def host_login
    @host = Host.new(
      password: params[:password]
    )
    key = Host.find_by(id: 1)
    if @host[:password] != key[:password]
      redirect_to "/"
    else
      session[:user_id] = key[:id]
      redirect_to host_path
    end
  end
    
  def host_logout
    session[:user_id] = nil
    redirect_to home_path
  end
    
  def self.booking_after_two_month
    @reservations = BookingDate.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
    reservation_data = []
    @reservations.each do |reservation|
      reservations_hash = {}
      reservations_hash.merge!(day: reservation.day.strftime("%Y-%m-%d"), time: reservation.time)
      reservation_data.push(reservations_hash)
    end
    reservation_data
  end

  def host_is
    key = Host.find(1)
    if key.blank?
      flash[:notice] = "予期せぬエラーが発生しています。"
      redirect_to "/"
    end
  end

  private
    def reservation_params
      params.require(:booking_date).permit(:day, :time, :name, :tell, :menu, :option, :s_time, :time)
    end

    def pre_create_cmd(first_time_num, minute_count, false_count)
      @reservation.e_time = times[first_time_num + minute_count]
      if @reservation.e_time.nil?
        @false_count -= 1
        flash[:notice] << "営業時間外です。"
      else
        if false_count == 0
          if @reservation.save
            create_cmd(first_time_num, minute_count, false_count)
          else
            flash[:notice] << "何か問題が発生しています。"
            @false_count -= 1
          end
        end
      end
    end
    
    def create_cmd(first_time_num,  minute_count, false_count)
      minute_count.times do |i|
        next_time = first_time_num + 1 + i
        reservation1 = BookingDate.new(
          day: params[:day],
          time: next_time,
          name: params[:name],
          tell: params[:tell],
          menu: params[:menu],
          date_time: params[:day].to_s + times[next_time],
          option: @reservation.option, 
          s_time: params[:time], 
          e_time: @reservation.e_time
        )
        if reservation1.save
          false_count += 0
        else
          false_count += 1
        end
      end
      @false_count = false_count
    end

    def times 
      times = 
            ["8:00",
             "8:30",
             "9:00",
             "9:30",
             "10:00",
             "10:30",
             "11:00",
             "11:30",
             "12:00",
             "12:30",
             "13:00",
             "13:30",
             "14:00",
             "14:30",
             "15:00",
             "15:30",
             "16:00",
             "16:30",
             "17:00",
             "17:30",
             "18:00",
             "18:30",
             "19:00",
             "19:30",
             "20:00",
             "20:30",
             "21:00"
      ]
    end

    def menus 
      menus = [
        "ボディケア 60分",
        "ボディケア 90分",
        "ボディケア 120分",
        "鍼灸マッサージ 60分",
        "鍼灸マッサージ 90分",
        "鍼灸マッサージ 120分",
        "美容鍼 60分",
        "期間限定 60分"
      ]
    end

    def options
      options = [
        "なし",
        "アロマオイル 20分"
      ]
    end
  end