import CustomAddDialog from '../component/CustomAddDialog'
import CustomEditDialog from '../component/CustomEditDialog'
import CustomSearch from '../component/CustomSearch'
import CustomTitle from '../component/CustomTitle'
import MemoItem from '../component/MemoItem'
import { MemoModel } from '../model/MemoModel'
import MemoTable from '../database/MemoTable'

@Entry
@Component
struct Index {
  //计数
  @State length: number = 0

  //缓存原始数据
  originMemoList: MemoModel[] = []

  //使用ForEach循环渲染对象数组
  @State memoList : MemoModel[] = []

  //是否展示编辑笔记自定义弹窗
  @State isAddDialogShow: boolean = false

  //新建暂存内容
  @State addContent: string = ''

  //新增笔记的方法
  creatMemo = () =>{
    const data: Date = new Date()
    const newMemo : MemoModel = new MemoModel(data.getTime(),data.getTime(),this.addContent)
    this.originMemoList.push(newMemo)
    this.memoList = this.originMemoList
    this.refreshByOrder()
    this.closeDialog()
  }
  //自定义弹窗 Rect
  @State isEditDialogShow : boolean = false

  // 新建内容
  @State editContent: string = ''

  //当前编辑的memo索引
  editingMemoIndex: number = -1

  //数据库初始化
  private MemoTable = new MemoTable(()=>{

  })

  //点击笔记时修改
  clickMemo = (memo: MemoModel)=>{
    for(let i=0;i<this.originMemoList.length;++i){
      this.originMemoList[i].id = memo.id
      this.editingMemoIndex = i
      this.isEditDialogShow = true
      this.editContent = memo.content
    }
  }

  //新增笔记
  createMemo=()=>{
    const date:Date = new Date()
    const newMemo:MemoModel = new MemoModel(0,date.getTime(),this.addContent)
    this.MemoTable.insertData(newMemo,(id:number)=>{
      newMemo.id = id
      this.originMemoList.push(newMemo)
      this.memoList = this.originMemoList
      this.refreshByOrder()
      this.closeDialog()
    })

  }

  //删除笔记
  deleteMemo=()=>{
    if(this.editingMemoIndex !== -1){
      this.MemoTable.deleteData(this.originMemoList[this.editingMemoIndex],()=>{
        this.originMemoList.splice(this.editingMemoIndex,1)
        this.memoList = this.originMemoList
        this.refreshByOrder()
        this.closeDialog()
      })
    }
  }

  //修改笔记
  saveMemo=()=>{
    const date:Date = new Date()
    this.originMemoList[this.editingMemoIndex].updateTime = date.getTime()
    this.originMemoList[this.editingMemoIndex].content = this.editContent
    this.MemoTable.updateData(this.originMemoList[this.editingMemoIndex],()=>{
      this.memoList = this.originMemoList
      this.refreshByOrder()
      this.closeDialog()
    })
  }

  //关闭弹窗的方法
  closeDialog = () => {
    this.isAddDialogShow = false
    this.addContent = ''
    this.isEditDialogShow = false
    this.editContent = ''
    this.editingMemoIndex = -1

    this.keywords = ''
  }

  //页面初始化前向页面加载数据
  aboutToAppear() {
    this.originMemoList = []
    this.memoList = []
    this.order = false
    this.keywords = ''
    this.isAddDialogShow = false
    this.isEditDialogShow = false
    this.addContent = ''
    this.editingMemoIndex = -1
    this.editContent = ''


    this.MemoTable.getRdbStore(()=>{
      this.MemoTable.query((result: MemoModel[])=>{
        this.originMemoList = result
        this.memoList = this.originMemoList
        this.refreshByOrder()
      })
    })



  }

  //排序图标切换 @state if
  @State @Watch('refreshByOrder') order : boolean = true

  //排序状态事件变化时间监听 @Watch
  refreshByOrder(){
    let orderList:MemoModel[] = []
    orderList = this.memoList.sort((a,b)=>{
      if(this.order){
        return a.updateTime - b.updateTime
      }else{
        return b.updateTime - a.updateTime
      }
    })
    const length = orderList.length
    this.memoList = orderList
  }

  //搜索关键词
  @State @Watch('onKeywordsChange') keywords: string = ''

  //监听搜索关键词的过滤方法
  onKeywordsChange(){
    if(this.keywords.length === 0) {
      this.memoList = this.originMemoList
      this.refreshByOrder()
    }else {
      let resultList: MemoModel[] = []

      for (const memoItem of this.originMemoList) {
        if (memoItem.content.includes(this.keywords)) {
          resultList.push(memoItem)
        }
      }
      this.memoList = resultList
    }
  }

  cleanKeywords = ()=> {
    this.keywords = ''
  }

  //@State list : string = '排序顺序'

  onClose = ()=> {
    this.isAddDialogShow = false
  }

  build() {
    Stack() {
      // BG

      // 页面
      Column(){
        CustomTitle({order:$order,isAddDialogShow:$isAddDialogShow})
        Divider()
          .color('#604637')

        //搜索框
        CustomSearch({keywords:$keywords,cleanKeywords:this.cleanKeywords})

        //列表
        Scroll(){
          Column(){
            ForEach(
              this.memoList,
              (memo:MemoModel,index:number)=>{
                MemoItem({memo:this.memoList[index],onMemoClick:this.clickMemo})
              },
              (memo:MemoModel)=>{return memo.content}
            )
          }
        }
        .height('70%')
      }
      //.alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%')

      //新建笔记按钮
      Row(){
        Image($r('app.media.add_one'))
          .width(40)
          .onClick(() => {
            this.isAddDialogShow = true
          })
      }.height('100%').alignItems(VerticalAlign.Bottom)




      //新建弹窗
      if(this.isAddDialogShow){
        CustomAddDialog({
          addContent:$addContent,
          onClose:this.closeDialog,
          onCreate:this.createMemo})
      }
      

      //编辑弹窗
      if(this.isEditDialogShow){
        CustomEditDialog({editContent:$editContent,onClose:this.closeDialog,onDelete:this.deleteMemo,onSave:this.saveMemo})
      }

    }
    .width('100%')
    .height('100%')
  }
}