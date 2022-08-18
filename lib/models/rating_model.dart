class RatingModel{
  
    String fullName = "";
    int ratGroup = -1;
    int ratInst = -1;
    double ball = -1;
    bool isCurrent = false;
    int maxPosInst = -1;
    int maxPosGroup = -1;

    RatingModel(this.fullName, this.ball, this.ratGroup, this.ratInst, this.maxPosGroup, this.maxPosInst, this.isCurrent);

    Map toJson() => {
        'fullName': fullName,
        'ratGroup': ratGroup,
        'ratInst': ratInst,
        'ball': ball,
        'isCurrent': isCurrent,
        'maxPosInst': maxPosInst,
        'maxPosGroup': maxPosGroup
      };
}