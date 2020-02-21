class Member {
  final String server;
  final String attendee_id;
  final String sched_date;
  final String provider_id;
  final String doctor_name;
  final String schedule_id;
  final String tokapikey;
  final String toksessionid;
  List  partpants;
  String toktoken;

  Member(this.server, this.attendee_id, this.sched_date,this.provider_id, this.doctor_name, this.schedule_id, this.tokapikey, this.partpants, this.toksessionid, this.toktoken) {

    if (sched_date == null) {
      throw new ArgumentError("login of Member cannot be null. "
          "Received: '$sched_date'");
    }
    if (doctor_name == null) {
      throw new ArgumentError("avatarUrl of Member cannot be null. "
          "Received: '$doctor_name'");

    }
  }
}