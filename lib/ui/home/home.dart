import "package:flutter/material.dart";

import "package:koreugi/usecase/.index.dart" as usecase;
import "package:koreugi/domain/.index.dart" as domain;

final class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _Buttons(),
          ),
          const _Footer(),
        ],
      ),
    );
  }
}

final class _Buttons extends StatefulWidget {
  _Buttons();

  final List<domain.BootButton> data = [
    const domain.BootButton(
      title: "Acceptance",
      color: Colors.redAccent,
    ),
    const domain.BootButton(
      title: "Training",
      color: Colors.yellowAccent,
    ),
    const domain.BootButton(
      title: "Production",
      color: Colors.tealAccent,
    ),
  ];

  @override
  _ButtonsState createState() => _ButtonsState();
}

final class _ButtonsState extends State<_Buttons> {
  bool isLoading = false;

  @override
  Widget build(context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final domain.BootButton item in widget.data)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(2, 16, 2, 0),
                      height: size.height,
                      child: _Button(
                        data: item,
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final result = await usecase.execute(item.title);
                          if (context.mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => _Terminus(
                                  message: result,
                                ),
                              ),
                            ).then((_) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

final class _Button extends StatefulWidget {
  _Button({
    required this.data,
    required this.onPressed,
  });

  final domain.BootButton data;
  final VoidCallback onPressed;
  final Color baseColor = Colors.grey.shade900;
  final Color textColor = Colors.grey;

  @override
  _ButtonState createState() => _ButtonState();
}

final class _ButtonState extends State<_Button> {
  late Color baseColor = baseColor;
  late Color textColor = textColor;

  @override
  void initState() {
    super.initState();
    baseColor = widget.baseColor;
    textColor = widget.textColor;
  }

  @override
  Widget build(context) {
    return FilledButton(
      onPressed: widget.onPressed,
      onHover: (bool value) {
        setState(() {
          baseColor = value ? widget.data.color : widget.baseColor;
          textColor = value ? Colors.black : widget.textColor;
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          widget.baseColor,
        ),
        overlayColor: WidgetStatePropertyAll(
          baseColor,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      child: Text(
        widget.data.title,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}

final class _Terminus extends StatelessWidget {
  const _Terminus({
    required this.message,
  });

  final String message;

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 128,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Text(
        "Developed by In Son",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}
