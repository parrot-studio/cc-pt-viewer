import Arcana from "./Arcana"

export default class QueryResult {
  public static create(arcanas: Arcana[], detail: string) {
    return new QueryResult(arcanas, detail)
  }

  public arcanas: Arcana[]
  public detail: string

  constructor(arcanas: Arcana[], detail: string) {
    this.arcanas = (arcanas || [])
    this.detail = (detail || "")
  }
}
