## 솔리디티

`코드내용` -> `byte Code` -> `tx` -> `마이닝...`

크립토좀비 하셈 (2챕터 까지)

### 컴파일러

nodeJS 가 해줌. (01010101010로)

EVM 해석 가능하게 해주는 ByteCode 기계도 버전이 있다.

```typescript
// HelloWorld.sol

// 하나의 컨트랙트는 하나의 객체다.
class HelloWorld {
    public text: string

    constructor() {
        this.text = 'Hello World!'
    }
    
    getText():string {
        return this.text
    }
    
    // ex
    setText(value:string ):void {
        this.text = value
    }
} 

const obj = new HelloWorld()
console.log(obj.getText())
```

1. Solidity 작성
2. Solidity Code Compile - `npm install solc`

**컴파일러 사용**

`npx solc [디렉토리/파일명]`

1. Bytecode 만들기위해, ABI 만들기 위해
> ABI : Application Binary Interface
> 
> 이더리움이 가지고 있는건 `ByteCode`
>

**ABI 생성**
`npx solc --bin --abi ./Contracts/HelloWorld.sol`

2. `send TX 에 from 과 data 속성만 있으면 스마트컨트랙트 배포 가능`

`to` 속성은 필요 없다.

**geth 실행**

`personal.sendTransaction({from:coinbase, to:'0x...',value:909009},'1234')`

**sendTx 비밀번호 넣는 이유**

UTC---- 파일명은 양방향 암호화 되어있다 (복호화가 가능하다.)

이떄 salt 를 password 로 사용해 개인키를 만든다.

이 개인키를 가지고 해킹당할수도 있어서,

`geth` 는 sendTransaction 할때 패스워드를 적어서 unlock 하게 만들었다.

**get.accounts 기준으로 unlock 명령어 사용**

`--unlock "0,1" --password "./node/password"`

`geth --datadir node --http --http.addr "localhost" --http.port 9001 --http.corsdomain "*" --http.api "admin,miner,net,txpool,web3,personal,eth" --syncmode full --networkid 1228 --port 30301 --allow-insecure-unlock --ws --ws.port 8547 --unlock "0,1" --password "./node/password"`

`get attach` 에서 변수설정을 할수있다.

ex) ingoo = 1
ingoo // 1

1. byteCode 에 "0x..." 저장.

`byteCode = "0x [bin파일 내용] " `

2. abi 만들어서 저장

`abi =  [abi 파일 내용]`

**txObject 에 넣을 건 from 과 data 다.**

data 에는 byteCode

이제 `txObject` 에 저장

```
txObject = {from:eth.coinbase,data:bytecode}
```

저장 한 후 tx 생성

`eth.sendTransaction(txObject)`

// txHash : '0x6537e3ccf798276b41e91b9b347aae5705853118469626a40fdc2c121ab157cc'

// personal.sendTransaction() 은 unlock 을 하지 않았을때 tx 보내는 상황에 사용

`eth.getTransaction([tx해쉬값])`

`eth.getTransactionReceipt([tx해쉬값])`

// contractAddress 라는 속성값이 생김 (CA 값이라 부름)

**CA**

// CA : '0xf0a28000c1ef61b442e40ceb0234058766b07ecb'

// 위 CA 는 HelloWorld 의 CA 값.

계정은 2가지 종류가 있다.

EOA : 돈 입금할때 썼던 게정

CA : 스마트 컨트랙트가 생성될 때, 해당 tx 의 스마트컨 트랙트 내용에 관한 키값

스마트 컨트랙트 함수 호출이나 내용을 변경하고 싶으면 CA 로 접근하면 된다.

### eth.contract(abi)

내가 받아올 컨트랙트의 객체를 지정한다.

`contract = eth.contract(abi)` // object

> at, getData, new 3개 가 추가되었다
> 
> at : function(address, cb),
> 
>

`instance = contract.at(CA)`

instance.getText({ from:eth.coinbase }) // 0x6bb75384e040d84aac9fd5493aef6d91f8147af12890f669d529416bbbcac454

instance.getText.call() // 'Hello World!!'

### instance 가 생성되는 시점

block 에 tx 가 들어갈 때 EVM 이 실행되면서 

**abi 파일이 필요한 이유**

**call : 가지고 있떤 애를 보는 행위, send: 상태변수를 바꾸는 행위**

**EVM 이 byte 로 변경값을 변환 할때 그 저장공간도 사용하는 거다! 그래서 타입이 굉장히 많은데,**

**이 타입들이 변경할때 용량 제한을 걸어서 낭비를 줄이는 거다.**

**컨트랙트의 변수 값을 변경할때 얼마나 많으 자원을 소모했냐가 gas 를 얼마나 소모했냐와 같다.**

**컨트랙트 배포를 위해 이번엔 이렇게 사용갈거다**
contract = eth.contract(abi)
instance = contract.new(txObject)

1. 솔리디티 코드 재작성
2. 컴파일 재작업
3. abi 변수, bytecode 변수 재설정
4. txObject 만들기
5. contract 변수 만들고
6. instance 변수 만들기
7. tx 를 블럭에 넣어서 ca 확인.
8. 확인한 ca 로 instance 변수 만들기
9. instance 변수 확인. ( getText, setText 존재 여부 확인)
10. instance.getText.call() 로 솔리디티 실행 확인해보기
11. instance.setText('hello ingoo?',{from:eth.coinbase}) // 0xcbdb91964705a502030472424fe98a6636fdb80b13a1d77d52504a24f0097a77
12. txpool 에 변경한 컨트랙트 들어갔으니 마이닝해서 확인
13. instance.getText.call() 로 상태변수 바뀌었는지 확인.

**위 과정을 처리해주는 프레임워크가 존재함.**

`Remix IDE`

`Truffle,HardHat`
