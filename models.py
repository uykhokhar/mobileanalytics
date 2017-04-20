from google.appengine.ext import ndb

from datetime import timedelta, datetime

class Session(ndb.Model):

    user = ndb.StringProperty()
    date = ndb.DateTimeProperty(auto_now_add=True)
    start = ndb.DateTimeProperty()
    end = ndb.DateTimeProperty()
    events = ndb.KeyProperty(kind='Event', repeated=True)
    touches = ndb.KeyProperty(kind='Touch', repeated=True)

    def query_30day_unique(self):
        pass

    # query_set = cls.query(projection=["field"], distinct=True)
    # set_of_field = [data.field for data in query_set]

    @classmethod
    def query_daily_unique(cls):
        days_to_subtract = 1
        last_day = datetime.now() - timedelta(days=days_to_subtract)
        print(last_day)

        #query = cls.query().fetch()
        #query = cls.query(cls.date > last_day).fetch()
        query = cls.query(cls.date > last_day).fetch()
        #print("QUERY {}".format(query))
        return query

        # new id's received


class Event(ndb.Model):

    name = ndb.StringProperty()


class Touch(ndb.Model):

    x = ndb.FloatProperty()
    y = ndb.FloatProperty()



