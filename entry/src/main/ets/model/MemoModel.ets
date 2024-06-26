@Observed
export class MemoModel{
  id:number
  updateTime:number
  content:string

  constructor(id:number, updateTime: number, content: string) {
    this.id = id
    this.updateTime = updateTime
    this.content = content
  }
}