class BDN {
  String? agncyBranchName;
  int? jobID;
  String? date;
  String? bdnNo;
  String? alongSide;
  String? pumpingCom;
  String? comp;
  int? jobItemID;
  String? jobProductCode;
  double? viscocity;
  double? waterContent;
  double? sulphurContent;
  double? density;
  double? flashPoint;
  double? grObVolume;
  double? grStVolumne;
  double? qty;
  double? barsixtyF;
  double? temp;
  List<SupConf>? supConf;
  String? nameStamp;
  String? fullName;
  String? remark;
  int? createdBy;
  int? agencyID;
  int? companyID;
  List<SampleIssue>? sampleIssue;
  String? etd;
  String? etdTime;
  double? grosstonnage;
  String? owneroparator;
  String? nextPort;
  String? dteVslETD;
  String? locationCode;
  String? berthedTypeCode;
  String? berthedLocation;
  String? bargeBdnNo;

  BDN(
      {this.agncyBranchName,
      this.jobID,
      this.date,
      this.bdnNo,
      this.alongSide,
      this.pumpingCom,
      this.comp,
      this.jobItemID,
      this.jobProductCode,
      this.viscocity,
      this.waterContent,
      this.sulphurContent,
      this.density,
      this.flashPoint,
      this.grObVolume,
      this.grStVolumne,
      this.qty,
      this.barsixtyF,
      this.temp,
      this.supConf,
      this.nameStamp,
      this.fullName,
      this.remark,
      this.createdBy,
      this.agencyID,
      this.companyID,
      this.sampleIssue,
      this.etd,
      this.etdTime,
      this.grosstonnage,
      this.owneroparator,
      this.nextPort,
      this.dteVslETD,
      this.locationCode,
      this.berthedTypeCode,
      this.berthedLocation,
      this.bargeBdnNo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agncyBranchName'] = agncyBranchName;
    data['jobID'] = jobID;
    data['date'] = date;
    data['bdnNo'] = bdnNo;
    data['alongSide'] = alongSide;
    data['pumpingCom'] = pumpingCom;
    data['comp'] = comp;
    data['jobItemID'] = jobItemID;
    data['jobProductCode'] = jobProductCode;
    data['viscocity'] = viscocity;
    data['waterContent'] = waterContent;
    data['sulphurContent'] = sulphurContent;
    data['density'] = density;
    data['flashPoint'] = flashPoint;
    data['grObVolume'] = grObVolume;
    data['grStVolumne'] = grStVolumne;
    data['qty'] = qty;
    data['barsixtyF'] = barsixtyF;
    data['temp'] = temp;
    if (supConf != null) {
      data['supConf'] = supConf!.map((v) => v.toJson()).toList();
    }
    data['nameStamp'] = nameStamp;
    data['fullName'] = fullName;
    data['remark'] = remark;
    data['createdBy'] = createdBy;
    data['agencyID'] = agencyID;
    data['companyID'] = companyID;
    if (sampleIssue != null) {
      data['sampleIssue'] = sampleIssue!.map((v) => v.toJson()).toList();
    }
    data['Etd'] = etd;
    data['EtdTime'] = etdTime;
    data['grosstonnage'] = grosstonnage;
    data['owneroparator'] = owneroparator;
    data['NextPort'] = nextPort;
    data['dteVslETD'] = dteVslETD;
    data['locationCode'] = locationCode;
    data['berthedTypeCode'] = berthedTypeCode;
    data['berthedLocation'] = berthedLocation;
    data['bargeBdnNo'] = bargeBdnNo;
    return data;
  }
}

class SupConf {
  String? regCode;
  bool? value;
  int? spValue;

  SupConf({this.regCode, this.value, this.spValue});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regCode'] = regCode;
    data['value'] = value;
    data['spValue'] = spValue;
    return data;
  }
}

class SampleIssue {
  String? sealNo;
  String? conSealNo;
  String? issueParty;

  SampleIssue({this.sealNo, this.conSealNo, this.issueParty});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sealNo'] = sealNo;
    data['conSealNo'] = conSealNo;
    data['issueParty'] = issueParty;
    return data;
  }
}
