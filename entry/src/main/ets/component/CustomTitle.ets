import { MemoModel } from '../model/MemoModel'
@Component
export default struct CustomTitle{
  @Link order: boolean
  @Link isAddDialogShow: boolean

  //originMemoList: MemoModel[] = []
  // 重用样式 @Styles
  @Styles titleButtonStyle(){
    .width(56)
    .height(32)
    .borderWidth(1)
    .borderColor('#ffc48741')
    .borderRadius(4)
  }

  build(){
    Row(){
      //heading1
      Column() {
        Text('全部备忘录')
          .fontSize(30)
          .fontWeight(600)
          .margin({ left: 20})
          .alignSelf(ItemAlign.Start)
          /*Text('共'+this.length+'条')
          .fontSize(15)
          .margin({ left: 20})
          .alignSelf(ItemAlign.Start)
          */
      }
      Blank()
      //排序
      Column(){
        if(this.order){
          Image($r('app.media.sort_amount_up'))
            .width(25)
        }else {
          Image($r('app.media.sort_amount_down'))
            .width(25)
        }
      }
      .margin({right: 20})
      .width(40)
      .height(32)
      .borderColor('#603647')
      .borderWidth(1)
      .borderRadius(4)
      .justifyContent(FlexAlign.Center)
      .onClick(()=>{
        this.order = !this.order
      })

    }
    .width('100%')
    .height(115)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#964b00', 0.3],['#8f4b0e', 1]]
    })
    .shadow({
      radius: 10,
      color: 'rgba(0,0,0,0.3)',
      offsetX: 0,
      offsetY: 10
    })

  }
}