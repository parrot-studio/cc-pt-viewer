import * as Bacon from "baconjs"

import Query, { QueryParam } from "../model/Query"
import QueryResult from "../model/QueryResult"
import Party from "../model/Party"
import { PartyLog } from "../model/PartyRepositroy"
import Arcana from "../model/Arcana"
import { FavoritesParams } from "../model/Favorites"

// tslint:disable:max-line-length
export default class MessageStream {
  public static readonly conditionStream: Bacon.Bus<QueryParam> = new Bacon.Bus()
  public static readonly queryStream: Bacon.Bus<QueryParam> = new Bacon.Bus()
  public static readonly queryLogsStream: Bacon.Bus<Query[]> = new Bacon.Bus()
  public static readonly resultStream: Bacon.Bus<QueryResult | null> = new Bacon.Bus()
  public static readonly partyStream: Bacon.Bus<Party> = new Bacon.Bus()
  public static readonly partiesStream: Bacon.Bus<PartyLog[]> = new Bacon.Bus()
  public static readonly memberCodeStream: Bacon.Bus<string> = new Bacon.Bus()
  public static readonly favoritesStream: Bacon.Bus<FavoritesParams> = new Bacon.Bus()
  public static readonly arcanaViewStream: Bacon.Bus<Arcana | null> = new Bacon.Bus()
  public static readonly historyStream: Bacon.Bus<string> = new Bacon.Bus()
}
