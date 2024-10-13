class CalenderJob {
  List<JobItems>? jobItems;
  int? jobID;
  String? jobNo;
  int? vesselID;
  String? vesselName;
  int? bargeAllocationID;
  String? assignedFromDateTime;
  String? assignedToDateTime;
  String? customerName;
  String? estimatedStart;
  String? estimatedEnd;
  String? imoNumber;
  String? port;
  String? locationName;
  String? berthedTypeCode;
  String? bunkerTanker;
  String? agncyBranchName;
  int? agencyBranchID;
  String? agencyBranchCode;
  int? bargeID;

  CalenderJob(
      {this.jobItems,
      this.jobID,
      this.jobNo,
      this.vesselID,
      this.vesselName,
      this.bargeAllocationID,
      this.assignedFromDateTime,
      this.assignedToDateTime,
      this.customerName,
      this.estimatedStart,
      this.estimatedEnd,
      this.imoNumber,
      this.port,
      this.locationName,
      this.berthedTypeCode,
      this.bunkerTanker,
      this.agncyBranchName,
      this.agencyBranchID,
      this.agencyBranchCode,
      this.bargeID});

  CalenderJob.fromJson(Map<String, dynamic> json) {
    if (json['jobItems'] != null) {
      jobItems = <JobItems>[];
      json['jobItems'].forEach((v) {
        jobItems!.add(JobItems.fromJson(v));
      });
    }
    jobID = json['jobID'];
    jobNo = json['jobNo'];
    vesselID = json['vesselID'];
    vesselName = json['vesselName'];
    bargeAllocationID = json['bargeAllocationID'];
    assignedFromDateTime = json['assignedFromDateTime'];
    assignedToDateTime = json['assignedToDateTime'];
    customerName = json['customerName'];
    estimatedStart = json['estimatedStart'];
    estimatedEnd = json['estimatedEnd'];
    imoNumber = json['imoNumber'];
    port = json['port'];
    locationName = json['locationName'];
    berthedTypeCode = json['berthedTypeCode'];
    bunkerTanker = json['bunkerTanker'];
    agncyBranchName = json['agncyBranchName'];
    agencyBranchID = json['agencyBranchID'];
    agencyBranchCode = json['agencyBranchCode'];
    bargeID = json['bargeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (jobItems != null) {
      data['jobItems'] = jobItems!.map((v) => v.toJson()).toList();
    }
    data['jobID'] = jobID;
    data['jobNo'] = jobNo;
    data['vesselID'] = vesselID;
    data['vesselName'] = vesselName;
    data['bargeAllocationID'] = bargeAllocationID;
    data['assignedFromDateTime'] = assignedFromDateTime;
    data['assignedToDateTime'] = assignedToDateTime;
    data['customerName'] = customerName;
    data['estimatedStart'] = estimatedStart;
    data['estimatedEnd'] = estimatedEnd;
    data['imoNumber'] = imoNumber;
    data['port'] = port;
    data['locationName'] = locationName;
    data['berthedTypeCode'] = berthedTypeCode;
    data['bunkerTanker'] = bunkerTanker;
    data['agncyBranchName'] = agncyBranchName;
    data['agencyBranchID'] = agencyBranchID;
    data['agencyBranchCode'] = agencyBranchCode;
    data['bargeID'] = bargeID;
    return data;
  }
}

class JobItems {
  int? jobItemDTID;
  String? productCode;
  double? maxQty;
  int? minQty;
  int? isItemExist;

  JobItems(
      {this.jobItemDTID,
      this.productCode,
      this.maxQty,
      this.minQty,
      this.isItemExist});

  JobItems.fromJson(Map<String, dynamic> json) {
    jobItemDTID = json['jobItemDTID'];
    productCode = json['productCode'];
    maxQty = json['maxQty'];
    minQty = json['minQty'];
    isItemExist = json['isItemExist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['jobItemDTID'] = jobItemDTID;
    data['productCode'] = productCode;
    data['maxQty'] = maxQty;
    data['minQty'] = minQty;
    data['isItemExist'] = isItemExist;
    return data;
  }
}
