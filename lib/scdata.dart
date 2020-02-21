class SCD {
  String server;
  String attendee_id;
  String sched_date;
  String practice_id;
  String ws_server;

  String provider_id;
  String doctor_name;
  String schedule_id;
  String tokapikey;
  String toksessionid;
  List  partpants;
  String toktoken;

  SCD(this.server, this.attendee_id, this.sched_date, this.practice_id, this.ws_server, this.provider_id, this.doctor_name, this.schedule_id, this.tokapikey, this.partpants, this.toksessionid, this.toktoken) {

    if (server == null) {
      throw new ArgumentError("Server cannot be null. "
          "Received: '$server'");
    }
    if (attendee_id == null) {
      throw new ArgumentError("Attendee_id cannot be null. "
          "Received: '$attendee_id'");

    }
  }
}
