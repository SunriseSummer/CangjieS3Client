/*
 * Copyright 2024 Primeton Information Technologies, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package s3client.core

/*
 *
 * @author: wangwb
 * @date: 2024-01-05
 */
public class S3MetricUtils {
    public static func measureDuration<T>(collection: S3MetricCollection, metric: String, fn: () -> T): T {
        if (collection.name == S3MetricCollection.EMPTY_COLLECTION.name) {
            return fn()
        }
        try {
            let beginTime = DateTime.nowUTC()
            let result = fn()
            collection.addRecord(metric, DateTime.nowUTC() - beginTime)
            return result
        } catch (ex: Exception) {
            collection.addRecord(
                S3Metrics.ERROR_TYPE.name,
                ex.toString()
            )
            throw ex
        }
    }
}
