class BDN {
  String? agncyBranchName;
  int? jobID;
  String? jobNo;
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
  int? isUpload;

  BDN(
      {this.agncyBranchName,
      this.jobID,
      this.jobNo,
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
      this.bargeBdnNo,
      this.isUpload});

  BDN.fromJson(Map<String, dynamic> json) {
    agncyBranchName = json['agncyBranchName'];
    jobID = json['jobID'];
    jobNo = json['jobNo'];
    date = json['date'];
    bdnNo = json['bdnNo'];
    alongSide = json['alongSide'];
    pumpingCom = json['pumpingCom'];
    comp = json['comp'];
    jobItemID = json['jobItemID'];
    jobProductCode = json['jobProductCode'];
    viscocity = json['viscocity'];
    waterContent = json['waterContent'];
    sulphurContent = json['sulphurContent'];
    density = json['density'];
    flashPoint = json['flashPoint'];
    grObVolume = json['grObVolume'];
    grStVolumne = json['grStVolumne'];
    qty = json['qty'];
    barsixtyF = json['barsixtyF'];
    temp = json['temp'];
    if (json['supConf'] != null) {
      supConf = <SupConf>[];
      json['supConf'].forEach((v) {
        supConf!.add(SupConf.fromJson(v));
      });
    }
    nameStamp = json['nameStamp'];
    fullName = json['fullName'];
    remark = json['remark'];
    createdBy = json['createdBy'];
    agencyID = json['agencyID'];
    companyID = json['companyID'];
    if (json['sampleIssue'] != null) {
      sampleIssue = <SampleIssue>[];
      json['sampleIssue'].forEach((v) {
        sampleIssue!.add(SampleIssue.fromJson(v));
      });
    }
    etd = json['etd'];
    etdTime = json['etdTime'];
    grosstonnage = json['grosstonnage'];
    owneroparator = json['owneroparator'];
    nextPort = json['nextPort'];
    dteVslETD = json['dteVslETD'];
    locationCode = json['locationCode'];
    berthedTypeCode = json['berthedTypeCode'];
    berthedLocation = json['berthedLocation'];
    bargeBdnNo = json['bargeBdnNo'];
    isUpload = json['isUpload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agncyBranchName'] = agncyBranchName;
    data['jobID'] = jobID;
    data['jobNo'] = jobNo;
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
    data['isUpload'] = isUpload;
    return data;
  }
}

class SupConf {
  String? regCode;
  int? value;
  double? spValue;

  SupConf({this.regCode, this.value, this.spValue});

  SupConf.fromJson(Map<String, dynamic> json) {
    regCode = json['regCode'];
    value = json['value'];
    spValue = json['spValue'];
  }

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

  SampleIssue.fromJson(Map<String, dynamic> json) {
    sealNo = json['sealNo'];
    conSealNo = json['conSealNo'];
    issueParty = json['issueParty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sealNo'] = sealNo;
    data['conSealNo'] = conSealNo;
    data['issueParty'] = issueParty;
    return data;
  }
}
