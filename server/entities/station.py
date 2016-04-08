class Station:

    def __init__(self, code, name, latitude, longitude, racks_count, bikes):
        self.id = code
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.racks_count = racks_count
        self.bikes = bikes
