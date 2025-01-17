from rest_framework import serializers

from iSkyLIMS_core.models import Samples, SampleProjectsFieldsValue, SampleProjectsFields


class CreateSampleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Samples
        fields = [
            "patientCore",
            "sampleName",
            "labRequest",
            "sampleType",
            "species",
            "sampleProject",
            "sampleEntryDate",
            "sampleCollectionDate",
            "sampleLocation",
            "onlyRecorded",
        ]


class CreateProjectDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = SampleProjectsFieldsValue
        fields = ["sample_id", "sampleProjecttField_id", "sampleProjectFieldValue"]


class SampleProjectFieldSerializer(serializers.ModelSerializer):
    class Meta:
        model = SampleProjectsFields
        fields = ["sampleProjectFieldName"]
