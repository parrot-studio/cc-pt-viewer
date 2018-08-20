import * as Bacon from "baconjs"

import Query, { QueryParam } from "./Query"
import QueryResult from "./QueryResult"
import Party from "./Party"
import { PartyLog } from "./Parties"
import Arcana from "./Arcana"
import { FavoritesParams } from "./Favorites"

// tslint:disable:max-line-length
export default class MessageStream {
  public static readonly conditionStream: Bacon.Bus<Bacon.EventStream<{}, QueryParam>, QueryParam> = new Bacon.Bus()
  public static readonly queryStream: Bacon.Bus<Bacon.EventStream<{}, QueryParam>, QueryParam> = new Bacon.Bus()
  public static readonly queryLogsStream: Bacon.Bus<Bacon.EventStream<{}, Query[]>, Query[]> = new Bacon.Bus()
  public static readonly resultStream: Bacon.Bus<Bacon.EventStream<{}, QueryResult | null>, QueryResult | null> = new Bacon.Bus()
  public static readonly partyStream: Bacon.Bus<Bacon.EventStream<{}, Party>, Party> = new Bacon.Bus()
  public static readonly partiesStream: Bacon.Bus<Bacon.EventStream<{}, PartyLog[]>, PartyLog[]> = new Bacon.Bus()
  public static readonly memberCodeStream: Bacon.Bus<Bacon.EventStream<{}, string>, string> = new Bacon.Bus()
  public static readonly favoritesStream: Bacon.Bus<Bacon.EventStream<{}, FavoritesParams>, FavoritesParams> = new Bacon.Bus()
  public static readonly arcanaViewStream: Bacon.Bus<Bacon.EventStream<{}, Arcana | null>, Arcana | null> = new Bacon.Bus()
  public static readonly historyStream: Bacon.Bus<Bacon.EventStream<{}, string>, string> = new Bacon.Bus()
}
