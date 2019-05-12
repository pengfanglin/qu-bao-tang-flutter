class SystemAccountModel {
	int accountId;
	String isDisable;
	String password;
	String roleIds;
	String headImg;
	String isDisableShow;
	String createTime;
	String systemOldPassword;
	String updateTime;
	String username;
	String token;

	SystemAccountModel({this.accountId, this.isDisable, this.password, this.roleIds, this.headImg, this.isDisableShow, this.createTime, this.systemOldPassword, this.updateTime, this.username, this.token});

	SystemAccountModel.fromJson(Map<String, dynamic> json) {
		accountId = json['accountId'];
		isDisable = json['isDisable'];
		password = json['password'];
		roleIds = json['roleIds'];
		headImg = json['headImg'];
		isDisableShow = json['isDisableShow'];
		createTime = json['createTime'];
		systemOldPassword = json['systemOldPassword'];
		updateTime = json['updateTime'];
		username = json['username'];
		token = json['token'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = Map<String, dynamic>();
		data['accountId'] = this.accountId;
		data['isDisable'] = this.isDisable;
		data['password'] = this.password;
		data['roleIds'] = this.roleIds;
		data['headImg'] = this.headImg;
		data['isDisableShow'] = this.isDisableShow;
		data['createTime'] = this.createTime;
		data['systemOldPassword'] = this.systemOldPassword;
		data['updateTime'] = this.updateTime;
		data['username'] = this.username;
		data['token'] = this.token;
		return data;
	}
}
