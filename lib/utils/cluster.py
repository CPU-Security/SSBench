import numpy as np

# Try importing sklearn
try:
    from sklearn.cluster import DBSCAN
    USE_SKLEARN = True
except ImportError:
    USE_SKLEARN = False


def _dbscan_1d_by_hand(data, eps, min_samples, filter_small_cluster):
    """
    Perform 1D DBSCAN clustering without sklearn.

    This function sorts the input data, applies a simple manual DBSCAN
    procedure, and returns the value range of each detected cluster.

    Args:
        data (array-like): Input 1D numeric data.
        eps (float): Maximum distance between two samples for them to be
            considered neighbors.
        min_samples (int): Minimum number of samples required to form a core point.
        filter_small_cluster (bool): Whether to discard clusters whose size is
            smaller than 10% of the total number of input samples.

    Returns:
        list[list[int]]: A list of cluster ranges, where each range is
        represented as [range_start, range_end].
    """
    data = np.sort(np.array(data))
    visited = np.zeros(len(data), dtype=bool)
    labels = np.full(len(data), -1, dtype=int)
    cluster_id = 0

    for i in range(len(data)):
        if visited[i]:
            continue
        visited[i] = True

        # Find neighbors
        neighbors = np.where(np.abs(data - data[i]) <= eps)[0]

        if len(neighbors) < min_samples:
            continue  # Mark as noise (-1)

        # Start a new cluster
        labels[i] = cluster_id
        seeds = set(neighbors)
        seeds.discard(i)

        while seeds:
            j = seeds.pop()
            if not visited[j]:
                visited[j] = True
                new_neighbors = np.where(np.abs(data - data[j]) <= eps)[0]
                if len(new_neighbors) >= min_samples:
                    seeds.update(new_neighbors)
            if labels[j] == -1:
                labels[j] = cluster_id

        cluster_id += 1

    # Extract cluster ranges
    ranges = []
    for label in set(labels):
        if label == -1:
            continue  # Ignore outliers
        cluster_points = data[labels == label]
        range_start = int(np.min(cluster_points))
        range_end = int(np.max(cluster_points))
        count = len(cluster_points)
        if filter_small_cluster and count < len(data) * 0.1:
            continue
        ranges.append([range_start, range_end])

    # # Print cluster ranges
    # print("Cluster Range:")
    # for r in ranges:
    #     print(f"  [{r[0]}, {r[1]}]")
    return ranges


def _dbscan_1d_from_sklearn(data, eps, min_samples, filter_small_cluster):
    """
    Perform 1D DBSCAN clustering using sklearn.

    The input data is reshaped into a 2D array because sklearn's DBSCAN
    expects input of shape (n_samples, n_features). The function returns
    the value range of each detected cluster.

    Args:
        data (np.ndarray): Input 1D numeric array.
        eps (float): Maximum distance between two samples for them to be
            considered neighbors.
        min_samples (int): Minimum number of samples required to form a core point.
        filter_small_cluster (bool): Whether to discard clusters whose size is
            smaller than 10% of the total number of input samples.

    Returns:
        list[list[int]]: A list of cluster ranges, where each range is
        represented as [range_start, range_end].
    """
    # DBSCAN requires 2D input, so reshape the array
    data_2d = data.reshape(-1, 1)

    # Set DBSCAN parameters
    # eps is the maximum distance between neighboring points in the same cluster
    # min_samples is the minimum number of points required to form a cluster
    db = DBSCAN(eps=eps, min_samples=min_samples).fit(data_2d)

    # Cluster labels: -1 indicates outliers
    labels = db.labels_

    # Extract cluster ranges
    ranges = []
    for label in set(labels):
        if label == -1:
            continue  # Ignore outliers
        cluster_points = data[labels == label]
        range_start = int(np.min(cluster_points))
        range_end = int(np.max(cluster_points))
        count = len(cluster_points)
        if filter_small_cluster and count < len(data) * 0.1:
            continue
        ranges.append([range_start, range_end])

    # Print cluster ranges
    print("Cluster Range:")
    for r in ranges:
        print(f"  [{r[0]}, {r[1]}]")

    return ranges


def cluster_timing_data(data, eps, min_samples, filter_small_cluster=False):
    """
    Cluster 1D timing data using DBSCAN.

    This function automatically selects the sklearn implementation when
    available; otherwise, it falls back to a manual implementation.

    Args:
        data (array-like): Input 1D numeric data.
        eps (float): Maximum distance between two samples for them to be
            considered neighbors.
        min_samples (int): Minimum number of samples required to form a core point.
        filter_small_cluster (bool, optional): Whether to discard clusters whose
            size is smaller than 10% of the total number of input samples.
            Defaults to False.

    Returns:
        list[list[int]]: A list of cluster ranges, where each range is
        represented as [range_start, range_end].
    """
    data = np.array(data)
    if USE_SKLEARN:
        ranges = _dbscan_1d_from_sklearn(data, eps, min_samples, filter_small_cluster)
    else:
        ranges = _dbscan_1d_by_hand(data, eps, min_samples, filter_small_cluster)
    return ranges