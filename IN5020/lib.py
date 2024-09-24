import numpy as np

class DataSet():
    def __init__(self, path):
        self.path = path
        data = np.loadtxt(path)
        data_training = []
        data_testing = []
        num_objects = data.shape[0]
        i = 0

        while i < num_objects-1:
            data_training.append(data[i])
            data_testing.append(data[i+1])
            i += 2

        self.training = np.array(data_training)
        self.testing = np.array(data_testing)


