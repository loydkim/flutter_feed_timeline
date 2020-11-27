final List<String> iconImageList = ['001-panda.png','002-lion.png','003-tiger.png','004-bear-1.png','005-parrot.png','006-rabbit.png','007-chameleon.png','008-sloth.png','009-elk.png','010-llama.png',
  '011-ant-eater.png','012-eagle.png','013-crocodile.png','014-beaver.png','015-hamster.png','016-walrus.png','017-bear.png','018-cheetah.png','019-kangaroo.png','020-duck.png',
  '021-goose.png','022-lemur.png','023-ostrich.png','024-owl.png','025-boar.png','026-penguin.png','027-camel.png','028-raccoon.png','029-hippo.png','030-monkey.png',
  '031-meerkat.png','032-snake.png','033-zebra.png','034-donkey.png','035-bull.png','036-goat-1.png','037-goat.png','038-horse.png','039-wolf.png','040-koala.png',
  '041-hedgehog.png','042-frog.png','043-turtle.png','044-gorilla.png','045-giraffe.png','046-deer.png','047-rhinoceros.png','048-elephant.png','049-puma.png','050-fox.png'];
const String firebaseCloudserverToken ='AAAAt7GY6Lo:APA91bHEq2Xi6m4716ciM8KgnGcHYw7YJ8K5X3_pFnzbzRkZzyX4nKRkbQFn8pKceSWVFXoYjYuToqGZcnrEhHqhI9gRG7OxQHtrjypm8o2LElq5v0zhOw0Sb64itx54DtpDfb9Du86H';
const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
class MyProfileData{
  final String myThumbnail;
  final String myName;
  final List<String> myLikeList;
  final List<String> myLikeCommnetList;
  final String myFCMToken;
  MyProfileData({this.myName,this.myThumbnail,this.myLikeList,this.myLikeCommnetList,this.myFCMToken});
}

const reportMessage = 'Thank you for reporting. We will determine the user\'s information within 24 hours and delete the account or take action to stop it.';
