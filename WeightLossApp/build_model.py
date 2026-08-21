import os

import torch
import torchvision
from torchvision.models import MobileNet_V2_Weights
import coremltools as ct


def main() -> None:
    weights = MobileNet_V2_Weights.IMAGENET1K_V2
    labels = weights.meta["categories"]

    model = torchvision.models.mobilenet_v2(weights=weights)
    model.eval()

    example = torch.rand(1, 3, 224, 224)
    traced = torch.jit.trace(model, example)

    mlmodel = ct.convert(
        traced,
        inputs=[ct.TensorType(name="input", shape=(1, 3, 224, 224))],
        classifier_config=ct.ClassifierConfig(class_labels=labels),
    )
    mlmodel.short_description = "FoodClassifier (MobileNetV2, ImageNet)"
    mlmodel.author = "coremltools"
    mlmodel.license = "Apache-2.0"

    out_dir = os.path.dirname(os.path.abspath(__file__))
    out_path = os.path.join(out_dir, "FoodClassifier.mlmodel")
    mlmodel.save(out_path)
    print("Saved model to", out_path)


if __name__ == "__main__":
    main()
