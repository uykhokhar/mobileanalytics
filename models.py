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
        return cls.query_num_days(1)

    @classmethod
    def query_30day_unique(cls):
        return cls.query_num_days(30)

    @classmethod
    def query_num_days(cls, num):
        days_to_subtract = num
        last_day = datetime.now() - timedelta(days=days_to_subtract)
        query = cls.query(cls.date > last_day).fetch(projection=["user"])
        users = []

        for session in query:
            if session.user not in users:
                users.append(session.user)

        return len(users)

    @classmethod
    def daily_sessions(cls):
        days_to_subtract = 1
        last_day = datetime.now() - timedelta(days=days_to_subtract)
        return cls.query(cls.date > last_day).count()

    @classmethod
    def avg_session_length(cls):
        days_to_subtract = 1
        last_day = datetime.now() - timedelta(days=days_to_subtract)
        query = cls.query(cls.date > last_day).fetch()
        count = cls.query(cls.date > last_day).count()

        sum = 0
        for item in query:
            print("********** NEW SESSION ************")
            print(item)
            print(item.end)
            print(item.start)
            sum += (item.end - item.start).total_seconds()

        return sum/count




class Event(ndb.Model):

    name = ndb.StringProperty()


class Touch(ndb.Model):

    x = ndb.FloatProperty()
    y = ndb.FloatProperty()



