class BookingController < ApplicationController

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
    if @reservation.option.nil?
      @option = "なし"
    else
      @option = options[@reservation.option]
    end
  end
  
  def create
    @reservation = BookingDate.new(
      day: params[:day],
      time: params[:time],
      start_time: params[:start_time],
      name: params[:name],
      tell: params[:tell],
      menu: params[:menu],
      option: params[:option]
      )
      @reservation[:date_time] = @reservation.day.to_s + @reservation.time
      first_time_num = times.index(@reservation.time)
      if @reservation.save
        false_count = 0
      else
        false_count = 1
      end
      
      if @reservation[:menu] % 2 == 0 && @reservation[:option].is_a?(Integer)
        create_cmd(first_time_num, 2, false_count)
      elsif @reservation[:menu] % 2 == 1 && @reservation[:option].is_a?(Integer)
        create_cmd(first_time_num, 3, false_count)
      elsif @reservation[:menu] % 2 == 0
        create_cmd(first_time_num, 1, false_count)
      elsif @reservation[:menu] % 2 == 1
      create_cmd(first_time_num, 2, false_count)
    end
    
    if @false_count == 0
      redirect_to action: :show,id: @reservation.id
    elsif @false_count == 1 && @minute_count == 2
      create_false_cmd(1)
      flash[:notice].push(1)
      redirect_to booking_date_path
    elsif @false_count == 2 && @minute_count == 3
      create_false_cmd(1)
      flash[:notice].push(2)
      redirect_to booking_date_path
    elsif @false_count == 1 && @minute_count == 3
      create_false_cmd(2)
      flash[:notice].push(3)
      redirect_to booking_date_path
    else
      @reservation.delete
      flash[:notice] = ["そのメニューでは登録できません", "最初から入力してください", 4]
      redirect_to booking_date_path
    end
  end 
  
  def delete
    date_time_now = params[:date_time]
    @reservation = BookingDate.find_by(date_time: date_time_now)
    if @reservation.menu == 10
      arry = BookingDate.where(day: @reservation.day).where(name: @reservation.name)
      arry.size.times do |i|
        arry[i].delete
      end
      flash[:notice] =  "その日の予定を削除しました"
      redirect_to host_path
    elsif @reservation.menu % 2 == 1 &&  @reservation[:option].is_a?(Integer)
      delete_cmd(4)
      if session[:user_id].is_a?(Integer)
        redirect_to host_path
      else
        redirect_to booking_date_path
      end
    elsif @reservation.menu % 2 == 0 && @reservation[:option].is_a?(Integer)
      delete_cmd(3)
      if session[:user_id].is_a?(Integer)
        redirect_to host_path
      else
        redirect_to booking_date_path
      end
    elsif @reservation.menu % 2 == 1
      delete_cmd(3)
      if session[:user_id].is_a?(Integer)
        redirect_to host_path
      else
        redirect_to booking_date_path
      end
    elsif @reservation.menu % 2 == 0
      delete_cmd(2)
      if session[:user_id].is_a?(Integer)
        redirect_to host_path
      else
        redirect_to booking_date_path
      end
    else
      flash[:notice] = "何か操作を間違えています。"
      redirect_to host_path
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

  private
    def reservation_params
      params.require(:booking_date).permit(:day, :time, :start_time)
    end
    
    def create_cmd(first_time_num,  minute_count, false_count)
      minute_count.times do |i|
        next_time = times[first_time_num + 1 + i]
        reservation1 = BookingDate.new(
          day: params[:day],
          time: next_time,
          start_time: params[:start_time],
          name: params[:name],
          tell: params[:tell],
          menu: params[:menu],
          date_time: params[:day].to_s + next_time,
          option: params[:option]
        )
        if reservation1.save
          false_count += 0
        else
          false_count += 1
        end
      end
      @minute_count = minute_count
      @false_count = false_count
    end

    def create_false_cmd(delete_count)
      delete_count.times do |i|
        reservation1 = BookingDate.find(@reservation.id + 1 + i)
        reservation1.delete
      end
      @reservation.delete
      flash[:notice] = ["そのメニューでは登録できません", "最初から入力してください"]
    end
  
    def delete_cmd(delete_num)
      delete_count = 0
      (delete_num * 2 - 1).times do |i|
        if delete_count == delete_num 
          break
        end
        @reservation1 = BookingDate.find(@reservation[:id] + (delete_num - 1) - i)
        if @reservation1.name == @reservation.name && @reservation1.tell == @reservation.tell && @reservation1.day == @reservation.day
          @reservation1.delete
          delete_count += 1
        else 
          delete_count += 0
        end
      end
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
        "鍼灸マッサージ 60分",
        "鍼灸マッサージ 90分",
        "美容鍼 60分",
      ]
    end

    def options
      options = [
        "ボディケア 30分",
        "鍼灸マッサージ 30分",
        "アロマオイル 30分",
        "期間限定 30分"
      ]
    end
  end