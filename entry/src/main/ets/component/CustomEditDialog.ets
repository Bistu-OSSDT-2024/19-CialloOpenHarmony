@Component
export default struct CustomEditDialog {
  @Link editContent: string
  onClose: () => void = () => {
  }
  onDelete: () => void = () => {
  }
  onSave: () => void = () => {
  }

  build() {
    Stack() {
      //蒙层
      Rect()
        .height('100%')
        .width('100%')
        .fill('rgba(0,0,0,0.4)')
        .onClick(() => {
          this.onClose()
        })
      //编辑卡片
      Column() {
        //文本输入
        Column() {
          TextArea({
            placeholder: '请输入笔记',
            text: this.editContent
          })
            .onChange((value: string) => {
              this.editContent = value
            })
            .height('100%')
        }
        .height('70%')
        .margin({ bottom: 20 })
        .padding(20)

        //按钮
        Row() {
          Column() {
            Image($r('app.media.return'))
              .width(24)
          }
          .backgroundColor('#BFA290')
          .width(60)
          .height(60)
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onClose()
          })

          Column() {
            Image($r('app.media.delete_five'))
              .width(24)
          }
          .backgroundColor('#BFA290')
          .width(60)
          .height(60)
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onDelete()
          })

          Column() {
            Image($r('app.media.check'))
              .width(24)
          }
          .backgroundColor('#BFA290')
          .width(60)
          .height(60)
          .borderRadius(30)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.onSave()
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .height('50%')
      .borderRadius({ topLeft: 16, topRight: 16 })
      .backgroundColor('#F0D988')
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
  }
}
@Preview
@Component
struct CustomEditDialogPreview{
  @State editContent:string = ''
  build() {
    CustomEditDialog({editContent:$editContent})
  }
}