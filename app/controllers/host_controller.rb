class HostController < BookingController
  before_action :move_to_signed_in

  def index
    @reservations = BookingDate.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
  end

  def show
    date_time_now = params[:date_time]
    @reservation = BookingDate.find_by(date_time: date_time_now)
  end

  def new 
    @reservation = BookingDate.new
    @day = params[:day]
    @time = params[:time]
    @start_time = DateTime.parse(@day + " " + @time + " " + "JST")
  end

  def create 
    @reservation = BookingDate.new(
      day: params[:day],
      time: params[:time],
      s_time: params[:s_time],
      e_time: params[:e_time],
      start_time: params[:start_time],
      name: 'ホスト',
      tell:  "0000",
      menu: 10
    )
    @reservation[:date_time] = @reservation.day.to_s + @reservation.time
    start_num = times.index(@reservation.s_time).to_i
    end_num = times.index(@reservation.e_time).to_i
    i = end_num - start_num
    if i < 0
      flash[:notice] = ["入力方法が間違えています"]
      redirect_to host_path
    elsif i == 0
      if @reservation.save
        redirect_to host_path
      else
        flash[:notice] = "予定を入れられませんでした"
        redirect_to host_path
      end
    elsif i > 0
      i += 1
      ary = []
      i.times do |j|
        if @reservation.save
          m = 1
        else
          ary.push("#{@reservation.time}は予約が入っています。確認してください")
          m = 2
        end
        time = times[start_num + j + 1].to_s
        date_time = @reservation.day.to_s + time
        @reservation = BookingDate.new(
          day: params[:day],
          time: time,
          date_time: date_time,
          s_time: params[:s_time],
          e_time: params[:e_time],
          start_time: params[:start_time],
          name: 'ホスト',
          tell:  "0000",
          menu: 10
        )
      end
      if m == 2
        flash[:notice] = ary
      end
      redirect_to host_path
    end
  end

  def host_logout
    session[:user_id] = nil
    redirect_to home_path
  end

  def move_to_signed_in
    if session[:user_id].nil?
      #サインインしていないユーザーはログインページが表示される
      redirect_to home_path
    end
  end

  private
  def times
    times = ["8:00",
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
             "21:00"]
  end
end