import 'package:flutter/material.dart';
import 'package:washine/app_export.dart';

/// 网络设置相关
class NetworkLogHostPage extends StatefulWidget {
  Uri? baseUri;
  Function(Uri? baseUri, {bool? isSuccess})? onChange;
  NetworkLogHostPage({Key? key, this.baseUri, this.onChange}) : super(key: key);

  @override
  _NetworkLogHostPageState createState() => _NetworkLogHostPageState();
}

class _NetworkLogHostPageState extends State<NetworkLogHostPage> {
  late final TextEditingController _domainController;
  late final TextEditingController _webController;

  Uri? currUri;

  @override
  void initState() {
    super.initState();
    if (widget.baseUri != null) {
      currUri = widget.baseUri;
    }
    _domainController = TextEditingController(text: 'http://');
    _webController = TextEditingController(text: 'https://www.baidu.com');
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _webController.dispose();
    super.dispose();
  }

  Future<void> setUrl(String url) async {
    if (widget.onChange != null) {
      widget.onChange!(Uri.parse(url));
    }
  }

  void reStart() {}

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      children: <Widget>[
        _buildInputHost(
          currUrl: '当前使用域名：${currUri?.origin}',
          controller: _domainController,
          hintText: '请输入新域名: scheme://host:port',
          onTap: () async {
            final newUri = Uri.tryParse(_domainController.text);
            final isHttpUrl = newUri != null &&
                newUri.scheme.startsWith(RegExp('^[https|http]'));
            if (newUri != null && isHttpUrl && !newUri.host.isnull) {
              await setUrl(newUri.origin).then((value) => Future.delayed(
                  const Duration(milliseconds: 1000), () => reStart()));
            } else {}
          },
        ),
        _buildFastSwitch(),
        const SizedBox(height: 10),
        _buildInputUrl(),
        const SizedBox(height: 40),
        _buildUriItem(des: '正式', uri: 'https://'),
        _buildUriItem(des: '预发布', uri: 'http://pre'),
        _buildUriItem(des: '测试1', uri: 'http://beta'),
        _buildUriItem(des: '测试2', uri: 'http://beta2'),
        const SizedBox(height: 40),
        Text(
          '当前Config:\n${widget.baseUri.toString().fixLines}',
          style: style(color: Colors.green),
          maxLines: 99,
        )
      ],
    );
  }

  Widget _buildInputUrl() {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _webController,
              keyboardType: TextInputType.url,
              style: style(),
              decoration: InputDecoration(
                hintText: '输入web地址',
                hintStyle:
                    style(color: Colors.grey.withOpacity(0.5), fontSize: 12),
                suffixIcon: InkWell(
                  onTap: () {
                    _webController.input('');
                    setState(() {});
                  },
                  child: const Icon(Icons.close, size: 18),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final isHttpUrl = !_webController.text.isnull &&
                  _webController.text.startsWith(RegExp('^[https|http]'));
              if (isHttpUrl) {
                // AppRoutes.to(AppletWebviewPage(url: 'https://www.baidu.com'));
              } else {
                // Toast.showText(' Web Url格式错误');
              }
            }.keyBoard(),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
            child: Text('进入Web', style: style()),
          ),
        ],
      ),
    );
  }

  Widget _buildInputHost({
    required TextEditingController controller,
    String? currUrl,
    String? hintText,
    VoidCallback? onTap,
  }) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            currUrl ?? '',
            style: const TextStyle(color: Colors.lightBlue, fontSize: 20),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 17),
            suffixIcon: InkWell(
              onTap: () {
                controller.input('');
                setState(() {});
              },
              child: const Icon(Icons.close, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onTap,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
            ),
            child: const Text('确定修改域名'),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFastSwitch() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            child: const Text('切换Release'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
            ),
            child: const Text('切换到Test'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: () => reStart(),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text('重启APP'),
          ),
        ),
      ],
    );
  }

  Widget _buildUriItem({String? des, String? uri}) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$des : ',
              style: const TextStyle(color: Colors.lightBlue),
            ),
          ),
          Text(
            uri ?? 'null',
            style: const TextStyle(color: Colors.red),
          ),
          const Spacer(),
          InkWell(
            // onTap: () => AppUtil.copy(uri),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.blue),
              child: const Text('copy', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}

class EnvAlertDialog extends StatelessWidget {
  final String? title;
  final bool withCancel;
  const EnvAlertDialog({Key? key, this.title, this.withCancel = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.only(top: 10),
            child: Text(title ?? '', style: style(color: Colors.red)),
          ),
          Expanded(
            child: withCancel
                ? Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                          ),
                          child: const Text('确定'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                          ),
                          child: const Text('取消'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: const Text('确定'),
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
